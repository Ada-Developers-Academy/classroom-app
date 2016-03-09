require 'httparty'

class PullRequestsController < ApplicationController
  def index
    @repos = Repo.all
  end

  def letsencrypt
    render plain: ENV['LE_AUTH_RESPONSE']
  end
end
