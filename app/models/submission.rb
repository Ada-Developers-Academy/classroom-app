class Submission < ActiveRecord::Base
  belongs_to :student
  belongs_to :repo

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
end
