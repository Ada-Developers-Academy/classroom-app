require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase
  class Validations < UserInviteTest
    test 'validates role is in predefined set' do
      valid_invite = user_invites(:instructor)
      # sanity check
      assert valid_invite.valid?

      User::ROLES.each do |role|
        valid_invite.role = role
        assert valid_invite.valid?
      end

      invalid_role = User::ROLES.sum
      valid_invite.role = invalid_role
      refute valid_invite.valid?
    end
  end
end
