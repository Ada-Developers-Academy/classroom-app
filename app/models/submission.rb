class Submission < ActiveRecord::Base
  belongs_to :student
  belongs_to :repo

  def pr_id
    self.pr_url.split('/').last
  end

  def type
    if self.pr_url && !self.feedback_url
      return 'warning'
    elsif self.pr_url && self.feedback_url
      return 'success'
    else
      return 'danger'
    end
  end
end
