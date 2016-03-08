require 'httparty'

class PullRequestsController < ApplicationController
  def index
    @repos = Repo.all
  end
end
