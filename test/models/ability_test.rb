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

    [:create, :read, :update, :destroy].each do |action|
      test_cannot_all action, Classroom, %i{sharks jets}
      test_cannot_all action, Assignment, %i{word_guess farmar}
      test_cannot_all action, Student, %i{shark jet}
      test_cannot_all action, Submission, %i{shark_word_guess jet_farmar}
      test_cannot_all action, User, %i{unknown instructor student}
      test_cannot_all action, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
    end
  end

  class UnauthorizedRules < AbilityTest
    def self.role
      :unknown
    end

    [:create, :read, :update, :destroy].each do |action|
      test_cannot_all action, Classroom, %i{sharks jets}
      test_cannot_all action, Assignment, %i{word_guess farmar}
      test_cannot_all action, Student, %i{shark jet}
      test_cannot_all action, Submission, %i{shark_word_guess jet_farmar}
      test_cannot_all action, User, %i{unknown instructor student}
      test_cannot_all action, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
    end
  end

  class InstructorRules < AbilityTest
    def self.role
      :instructor
    end

    [:create, :read, :update, :destroy].each do |action|
      test_can_all action, Classroom, %i{sharks jets}
      test_can_all action, Assignment, %i{word_guess farmar}
      test_can_all action, Student, %i{shark jet}
      test_can_all action, Submission, %i{shark_word_guess jet_farmar}
      test_can_all action, User, %i{unknown instructor student}
      test_can_all action, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
    end
  end

  class StudentRules < AbilityTest
    class General < StudentRules
      def self.role
        :student
      end

      [:create, :read, :update, :destroy].each do |action|
        test_cannot_all action, Classroom, %i{sharks jets}
        test_cannot_all action, Assignment, %i{word_guess farmar}
        test_cannot_all action, User, %i{unknown instructor student}
        test_cannot_all action, UserInvite, %i{valid_instructor valid_student valid_unknown accepted}
      end

      [:create, :update, :destroy].each do |action|
        test_cannot_all action, Student, %i{shark jet}
        test_cannot_all action, Submission, %i{shark_word_guess jet_farmar}
      end
    end

    class Ownership < StudentRules
      def self.role
        :student_shark
      end

      # Student users can view their own submissions
      test_can :read, "own submissions", proc { submissions(:shark_word_guess) }

      # But not other students' submissions
      test_cannot :read, "other submissions", proc { submissions(:jet_farmar) }

      # Student users can view themselves
      test_can :read, "own Student record", proc { students(:shark) }

      # But not other students
      test_cannot :read, "other Student records", proc { students(:jet) }
    end
  end
end
