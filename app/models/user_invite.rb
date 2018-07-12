class UserInvite < ApplicationRecord
  # TODO: belongs_to now is required by default. Should these be changed to optional?
  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
  belongs_to :inviter, class_name: 'User'
  belongs_to :cohort, dependent: :destroy, optional: true # TODO: had to make optional make model test work. See: models/user_invite_test.rb:13

  validates_with UserRoleValidator
  validates :inviter, presence: true
  validate :inviter_must_be_instructor
  validates :github_name, presence: true, uniqueness: { conditions: -> { acceptable } }
  validate :only_students_have_cohort

  scope :acceptable, -> { where(accepted: false) }

  default_scope { order(created_at: :desc) }

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
