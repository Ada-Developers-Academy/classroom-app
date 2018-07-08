class Cohort < ApplicationRecord
  has_and_belongs_to_many :repos
  
  def display_name
    "#{number}: #{name}"
  end
end
