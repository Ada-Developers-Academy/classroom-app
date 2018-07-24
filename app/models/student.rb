class Student < ApplicationRecord
  # TODO: belongs_to now is required by default. Should these be changed to optional?
  # http://guides.rubyonrails.org/upgrading_ruby_on_rails.html#active-record-belongs-to-required-by-default-option
  belongs_to :user, foreign_key: :github_name, primary_key: :github_name, optional: true # change to optional because error
  belongs_to :classroom
  has_and_belongs_to_many :submissions

  validates :name, :github_name, :email, presence: true
end
