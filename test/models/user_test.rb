require 'test_helper'

class UserTest < ActiveSupport::TestCase
  class Validations < UserTest
    test 'validates role is in predefined set' do
      valid_user = users(:unknown)
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

  class AcceptInvite < UserTest
    def invitee
      users(:unknown)
    end

    test 'raises ArgumentError for invalid invites' do
      invite = user_invites(:invalid)

      assert_raises(ArgumentError) do
        invitee.accept_invite(invite)
      end
    end
  end
end
