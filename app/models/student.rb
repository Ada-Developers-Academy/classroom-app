class Student < ActiveRecord::Base
  belongs_to :cohort
  has_many :submissions

  validates :name, :github_name, :email, presence: true
end
