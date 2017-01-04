class Repo < ActiveRecord::Base
  has_and_belongs_to_many :cohorts

  def pulls_url
    "http://github.com/" + self.repo_url + "/pulls"
  end
end
