require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  class Associations < StudentTest
    test 'can be associated with a User account' do
      student = students(:shark)

      assert_not_nil student.user
      assert_equal student.user, users(:student_shark)
    end

    test 'can be unassociated with a User account' do
      student = students(:jet)

      assert_nil student.user
    end
  end
end
