class SubmissionGroup < ApplicationRecord
  belongs_to :submission
  belongs_to :assignment
  has_many :students_submission_groups
end
