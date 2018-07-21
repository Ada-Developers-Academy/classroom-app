class Cohort < ApplicationRecord
  has_many :classroom #, dependent: :destroy  QUESTIONS: needed?
  validates :repo_name, presence: true
end
