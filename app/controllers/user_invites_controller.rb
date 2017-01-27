class UserInvitesController < ApplicationController
  def index
    @invites = UserInvite.acceptable
  end
end
