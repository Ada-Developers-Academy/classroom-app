class UserInvite < ActiveRecord::Base
  belongs_to :inviter, class_name: 'User'
  belongs_to :cohort, dependent: :destroy

  validates_with UserRoleValidator
  validates :inviter, presence: true
  validate :inviter_must_be_instructor
  validates :github_name, presence: true, uniqueness: true
  validate :only_students_have_cohort

  scope :acceptable, -> { where(accepted: false) }

  def cohort?
    cohort.present?
  end

  private

  # Validations
  def inviter_must_be_instructor
    if inviter && inviter.role != 'instructor'
      errors.add(:inviter, "must be an instructor")
    end
  end

  def only_students_have_cohort
    if role == 'student'
      errors.add(:cohort, "must be set for student invitations") unless cohort?
    else
      errors.add(:cohort, "may only be set for student invitations") if cohort?
    end
  end
end
