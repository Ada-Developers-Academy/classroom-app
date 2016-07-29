class Submission < ActiveRecord::Base
  has_one :person
  has_one :repo
end
