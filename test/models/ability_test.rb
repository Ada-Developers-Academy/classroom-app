require 'test_helper'

class AbilityTest < ActiveSupport::TestCase
  class InstructorRules < AbilityTest
    def user
      users(:instructor)
    end

    def ability
      Ability.new(user)
    end

    test 'instructors can read all cohorts' do
      [:sharks, :jets].each do |cohort|
        assert ability.can? :read, cohorts(cohort)
      end
    end

    test 'instructors can read all repos' do
      [:word_guess, :farmar].each do |repo|
        assert ability.can? :read, repos(repo)
      end
    end

    test 'instructors can read all students' do
      [:shark, :jet].each do |student|
        assert ability.can? :read, students(student)
      end
    end

    test 'instructors can read all submissions' do
      [:shark_word_guess, :jet_farmar].each do |submission|
        assert ability.can? :read, submissions(submission)
      end
    end

    test 'instructors can read all users' do
      [:unknown, :instructor, :student].each do |user|
        assert ability.can? :read, users(user)
      end
    end

    test 'instructors can read all user invites' do
      [:valid_instructor, :valid_student, :valid_unknown, :accepted].each do |invite|
        assert ability.can? :read, user_invites(invite)
      end
    end
  end
end
