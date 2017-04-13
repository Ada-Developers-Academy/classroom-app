require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  def self.test_ability(verb, action, desc, objects)
    test "#{role.to_s.pluralize} #{verb} #{action} #{desc}" do
      Array(instance_eval(&objects)).each do |obj|
        assert ability.send(:"#{verb}?", action, obj)
      end
    end
  end

  def self.test_can(action, desc, objects)
    test_ability(:can, action, desc, objects)
  end

  def self.test_cannot(action, desc, objects)
    test_ability(:cannot, action, desc, objects)
  end

  def self.test_can_all(action, model, fixtures)
    table = model.table_name
    test_can(action, "all #{table}", proc do
      fixtures.map{ |f| send(:"#{table}", f) }
    end)
  end

  def self.test_cannot_all(action, model, fixtures)
    table = model.table_name
    test_cannot(action, "all #{table}", proc do
      fixtures.map{ |f| send(:"#{table}", f) }
    end)
  end

  def ability
    Ability.new(user)
  end

  def user
    users(self.class.role)
  end

  class GuestRules < AbilityTest
    def self.role
      "guest"
    end

    def user
      nil
    end

    test_cannot_all :read, Cohort, %i{sharks jets}
    test_cannot_all :read, Repo, %i{word_guess farmar}
    test_cannot_all :read, Student, %i{shark jet}
    test_cannot_all :read, Submission, %i{shark_word_guess jet_farmar}
    test_cannot_all :read, User, %i{unknown instructor student}
    test_cannot_all :read, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
  end

  class UnauthorizedRules < AbilityTest
    def self.role
      :unknown
    end

    test_cannot_all :read, Cohort, %i{sharks jets}
    test_cannot_all :read, Repo, %i{word_guess farmar}
    test_cannot_all :read, Student, %i{shark jet}
    test_cannot_all :read, Submission, %i{shark_word_guess jet_farmar}
    test_cannot_all :read, User, %i{unknown instructor student}
    test_cannot_all :read, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
  end

  class InstructorRules < AbilityTest
    def self.role
      :instructor
    end

    test_can_all :read, Cohort, %i{sharks jets}
    test_can_all :read, Repo, %i{word_guess farmar}
    test_can_all :read, Student, %i{shark jet}
    test_can_all :read, Submission, %i{shark_word_guess jet_farmar}
    test_can_all :read, User, %i{unknown instructor student}
    test_can_all :read, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
  end

  class StudentRules < AbilityTest
    def self.role
      :student
    end

    test_cannot_all :read, Cohort, %i{sharks jets}
    test_cannot_all :read, Student, %i{shark jet}
    test_cannot_all :read, User, %i{unknown instructor student}
    test_cannot_all :read, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
  end
end
