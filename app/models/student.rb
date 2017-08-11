class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :submissions

  validates :name, :github_name, :email, presence: true

  def submission_for_repo(repo)
    submissions.where(repo: repo).first
  end
end
