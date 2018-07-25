class Assignment < ApplicationRecord
  # TODO: does the belongs_to issue (ie being required as default) apply to has_and_belongs_to_many? Should these be
  # changed to optional?
  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
  belongs_to :classroom
  has_many :submissions, dependent: :destroy
  validates :repo_url, presence: true
  # validates :classroom, presence: true


  BASE_GITHUB_URL = "http://github.com/"

  default_scope { order(created_at: :desc) }

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
