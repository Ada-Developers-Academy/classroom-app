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
  end
end
