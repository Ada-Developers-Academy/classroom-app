class UserInvite < ApplicationRecord
  # QUESTION: belongs_to now is required by default. Should these be changed to optional?
  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
  belongs_to :inviter, class_name: 'User'
  # TODO: why dependent: destroy
  # belongs_to :classroom, optional: true # NOTE: had to make optional make model test work.

  # belongs_to :classroom, dependent: :destroy, optional: true # NOTE: had to make optional make model test work.

  validates_with UserRoleValidator
  validates :inviter, presence: true
  validate :inviter_must_be_instructor
  validates :github_name, presence: true, uniqueness: { conditions: -> { acceptable } }
  validates :uid, presence: true, uniqueness: true

  # TODO: was only_students_have_classroom. Should we revert back to this when we make cohorts?
  validate :only_students_have_classroom

  scope :acceptable, -> { where(accepted: false) }

  default_scope { order(created_at: :desc) }

  def classroom?
    classroom.present?
  end

  private

  # Validations
  def inviter_must_be_instructor
    if inviter && inviter.role != 'instructor'
      errors.add(:inviter, "must be an instructor")
    end
  end

  # TODO: was only_students_have_classroom. Should we revert back to this when we make cohorts? Obviously would need to
  # address changes in method as well
  def only_students_have_classroom
    if role == 'student'
      errors.add(:classroom, "must be set for student invitations") unless classroom?
    else
      errors.add(:classroom, "may only be set for student invitations") if classroom?
    end
  end
end
