class Cohort < ActiveRecord::Base
  has_and_belongs_to_many :repos
  
  def display_name
    "#{number}: #{name}"
  end
end
