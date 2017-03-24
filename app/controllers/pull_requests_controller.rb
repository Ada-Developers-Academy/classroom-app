# require 'httparty'

class PullRequestsController < ApplicationController
  skip_before_action :require_login, only: [:home]

  def home
    if current_user
      redirect_to pull_requests_path
    end
  end

  def index
    @repos = Repo.all
  end

end
