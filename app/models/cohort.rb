class Cohort < ApplicationRecord
  # TODO: does the belongs_to issue (ie being required as default) apply to has_and_belongs_to_many? Should these be
  # changed to optional?
  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
  has_and_belongs_to_many :repos
  
  def display_name
    "#{number}: #{name}"
  end
end
