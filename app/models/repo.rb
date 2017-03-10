class Repo < ActiveRecord::Base
  has_and_belongs_to_many :cohorts
  has_many :submissions, dependent: :destroy
  validates :repo_url, presence: true

  BASE_GITHUB_URL = "http://github.com/"

  def pulls_url
    full_repo_url + "/pulls"
  end

  def full_repo_url
    BASE_GITHUB_URL + self.repo_url
  end

  def branch_url
    full_repo_url + "/blob/master/"
  end

  def feedback_template_url
    branch_url + "feedback.md"
  end

  def pr_template_url
    branch_url + ".github/PULL_REQUEST_TEMPLATE"
  end
end
