require 'test_helper'

class UserTest < ActiveSupport::TestCase
  class Validations < UserTest
    test 'validates role is in predefined set' do
      valid_user = users(:valid)
      # sanity check
      assert valid_user.valid?

      User::ROLES.each do |role|
        valid_user.role = role
        assert valid_user.valid?
      end

      invalid_role = User::ROLES.sum
      valid_user.role = invalid_role
      refute valid_user.valid?
    end
  end
end
