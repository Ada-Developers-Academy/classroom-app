class Submission < ApplicationRecord
  belongs_to :student
  belongs_to :repo
  belongs_to :feedback_provider, class_name: 'User', foreign_key: 'user_id'

  GRADES = [
    :meet_standard,
    :approach_standard,
    :not_standard
  ]

  enum grade: GRADES

  scope :with_pr, ->(url) { where(pr_url: url) }
  scope :grouped_with, ->(sub) { with_pr(sub.pr_url) }

  def pr_id
    self.pr_url.split('/').last
  end

  def update_group(attrs)
    if repo.individual?
      update(attrs)
    else
      Submission.grouped_with(self).update_all(attrs)
    end
  end

  def student_names
    if repo.individual?
      student.name
    else
      Submission.grouped_with(self).map do |sub|
        sub.student.name
      end.join(' & ')
    end
  end
end
