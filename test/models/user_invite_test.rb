require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase
  class Validations < UserInviteTest
    def valid_invite
      user_invites(:instructor)
    end

    setup do
      # sanity check
      assert valid_invite.valid?
    end

    test 'validates role is in predefined set' do
      User::ROLES.each do |role|
        valid_invite.role = role
        assert valid_invite.valid?
      end

      invalid_role = User::ROLES.sum
      valid_invite.role = invalid_role
      refute valid_invite.valid?
    end

    test 'validates inviter exists' do
      valid_invite.inviter = nil
      refute valid_invite.valid?
    end

    test 'validates inviter is an instructor' do
      # Instructors CAN invite
      valid_invite.inviter = users(:instructor)
      assert valid_invite.valid?

      # Students CANNOT invite
      valid_invite.inviter = users(:student)
      refute valid_invite.valid?

      # Unknowns CANNOT invite
      valid_invite.inviter = users(:unknown)
      refute valid_invite.valid?
    end

    test 'validates GitHub name is set' do
      valid_invite.github_name = nil
      refute valid_invite.valid?

      valid_invite.github_name = ''
      refute valid_invite.valid?
    end
  end
end
