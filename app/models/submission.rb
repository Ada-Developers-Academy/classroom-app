class Submission < ActiveRecord::Base
  belongs_to :student
  belongs_to :repo

  def pr_id
    self.pr_url.split('/').last
  end

  def find_shared
    Submission.where(pr_url: self.pr_url)
  end
end
