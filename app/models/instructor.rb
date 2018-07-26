class Instructor < ApplicationRecord
  has_many :submissions
  validates :uid, presence: true
end
