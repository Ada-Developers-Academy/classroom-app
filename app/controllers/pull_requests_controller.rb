require 'httparty'
require 'pry'

class PullRequestsController < ApplicationController
  def index
    @repos = Repo.all
  end
end
