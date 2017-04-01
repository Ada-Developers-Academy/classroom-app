class UserInvite < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  belongs_to :cohort, dependent: :destroy

  validates_with UserRoleValidator
  validates :inviter, presence: true
  validate :inviter_must_be_instructor
  validates :github_name, presence: true, uniqueness: true

  scope :acceptable, -> { where(accepted: false) }

  private

  # Validations
  def inviter_must_be_instructor
    if inviter && inviter.role != 'instructor'
      errors.add(:inviter, "must be an instructor")
    end
  end
end
