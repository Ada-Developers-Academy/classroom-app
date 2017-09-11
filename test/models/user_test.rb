require 'test_helper'

class UserTest < ActiveSupport::TestCase
  class Validations < UserTest
    setup do
      @valid_user = users(:unknown)
      # sanity check
      assert @valid_user.valid?
    end

    test 'validates role is in predefined set' do
      User::ROLES.each do |role|
        @valid_user.role = role
        assert @valid_user.valid?
      end

      invalid_role = User::ROLES.sum
      @valid_user.role = invalid_role
      refute @valid_user.valid?
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

    test 'sets role based on invite' do
      invite = user_invites(:valid_student)
      # sanity check
      refute_equal invite.role, invitee.role

      invitee.accept_invite(invite)

      assert_equal invite.role, invitee.role
    end

    test 'marks invite as accepted' do
      invite = user_invites(:valid_student)
      # sanity check
      refute invite.accepted?

      invitee.accept_invite(invite)

      assert invite.accepted?
    end

    test 'raises ArgumentError for already accepted invites' do
      invite = user_invites(:accepted)
      # sanity check
      assert invite.accepted?

      assert_raises(ArgumentError) do
        invitee.accept_invite(invite)
      end
    end
  end
end
