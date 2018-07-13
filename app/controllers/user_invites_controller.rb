class UserInvitesController < ApplicationController
  load_and_authorize_resource instance_name: :invite

  def index
    @invites = @invites.acceptable
  end

  def new_student; end
  def new_instructor; end

  # TODO: tell Leti about this because it's fancy as fuck
  def create
    action = :"create_#{params[:role]}"
    return send(action) if respond_to?(action, true) # NOTE: calls create_student or instructor (see below)

    render not_found
  end

  private

  def create_student
    github_names = params[:github_names].split(/[ \t\r\n]+/).map(&:strip).uniq
    classroom = Classroom.find_by(id: params[:classroom_id])
    if !classroom.present?
      return redirect_to user_invites_path,
                         alert: "Could not find classroom with ID #{params[:classroom_id]}"
    end

    msgs = github_names.map do |name|
      invite = UserInvite.create({
        inviter: current_user,
        github_name: name,
        role: 'student',
        classroom: classroom
      })

      if invite.persisted?
        [true, "Invited #{name}"]
      else
        [false, "Could not invite #{name} because #{invite.errors.full_messages.first}"]
      end
    end

    redirect_to user_invites_path, {
      notice: msgs.select(&:first).map(&:second),
      alert:  msgs.reject(&:first).map(&:second),
    }
  end

  def create_instructor
    name = params[:github_name]
    invite = UserInvite.create({
      inviter: current_user,
      github_name: name,
      role: 'instructor'
    })

    if invite.persisted?
      redirect_to user_invites_path, notice: "Successfully invited Github account #{name}"
    else
     flash[:alert] = "Could not invite #{name} because #{invite.errors.full_messages.first}"
     render "new_instructor"
    end
  end
end
