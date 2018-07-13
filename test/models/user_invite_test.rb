require 'test_helper'

class UserInviteTest < ActiveSupport::TestCase
  class Validations < UserInviteTest
    def valid_invite
      user_invites(:valid_instructor)
    end

    setup do
      # puts user_invites(:valid_instructor).inspect
      # puts user_invites(:valid_instructor).valid?.inspect
      # sanity check
      assert valid_invite.valid?
    end

    test 'validates role is in predefined set' do
      User::ROLES.each do |role|
        invite = user_invites(:"valid_#{role}")
        refute_nil invite
        assert_equal role, invite.role
        assert invite.valid?
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

    test 'validates GitHub account cannot be invited multiple times' do
      valid_attrs = valid_invite.attributes.except("id", "created_at", "updated_at")

      # Create a duplicate invite
      invalid_invite = UserInvite.new(valid_attrs)
      refute invalid_invite.valid?
    end

    test 'validates classroom must be specified when role is student' do
      valid_invite.classroom = nil
      valid_invite.role = 'student'
      refute valid_invite.valid?
    end

    test 'validates classroom must not be specified when role is not student' do
      valid_invite.classroom = classrooms(:sharks)

      (User::ROLES - ['student']).each do |role|
        valid_invite.role = role
        refute valid_invite.valid?
      end
    end
  end
end
