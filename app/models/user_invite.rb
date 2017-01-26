class UserInvite < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'

  validates_with UserRoleValidator
  validates :inviter, presence: true
end
