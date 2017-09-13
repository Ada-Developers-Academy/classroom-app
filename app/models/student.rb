class Student < ActiveRecord::Base
  belongs_to :user, foreign_key: :github_name, primary_key: :github_name
  belongs_to :cohort
  has_many :submissions

  validates :name, :github_name, :email, presence: true
end
