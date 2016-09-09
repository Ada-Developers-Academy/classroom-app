# require 'httparty'

class PullRequestsController < ApplicationController
  skip_before_action :require_login, only: [:home]

  def home

  end

  def index
    @repos = Repo.all
  end

end
