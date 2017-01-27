class UserInvitesController < ApplicationController
  def index
    @invites = UserInvite.acceptable
  end

  def new
    role = params[:role]
    return unless role.present?

    render "new_#{role}"
  rescue ActionView::MissingTemplate
    render not_found
  end
end
