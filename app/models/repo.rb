class Repo < ActiveRecord::Base
  has_and_belongs_to_many :cohorts
  has_many :submissions

  BASE_GITHUB_URL = "http://github.com/"

  def pulls_url
    full_repo_url + "/pulls"
  end

  def full_repo_url
    BASE_GITHUB_URL + self.repo_url
  end
end
