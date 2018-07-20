require 'github_user_info'

class UserInvitesController < ApplicationController
  load_and_authorize_resource instance_name: :invite

  def index
    acceptable_invites = @invites.acceptable
    render json: { acceptable_invites: acceptable_invites }, status: :ok
  end

  def new_student; end
  def new_instructor; end

  # TODO: tell Leti about this because it's fancy as fuck
  def create
    action = :"create_#{params[:role]}"
    return send(action) if respond_to?(action, true) # NOTE: calls create_student or instructor (see below)

    render json: { errors: "Could not create" }, status: 404
  end

  private

  # @param :github_names must be a String of valid, unique Github username separated by a tab, end of line, or new line
  # @param :classroom_id much be a valid classroom id
  def create_student
    github_names = params[:github_names].split(/[ \t\r\n]+/).map(&:strip).uniq
    classroom = Classroom.find_by(id: params[:classroom_id])
    if !classroom.present?
      render json: { errors: "Could not find classroom with ID #{params[:classroom_id]}" }, status: 404
      return
    end

    msgs = github_names.map do |name|
      github_uid = GitHubUserInfo.get_uid_from_gh(name)
      invite = UserInvite.create({
        inviter: current_user,
        github_name: name,
        role: 'student',
        classroom: classroom,
        uid: github_uid
      })

      if invite.persisted? # QUESTION: what is this?
        [true, "Invited #{name}"]
      else
        [false, "Could not invite #{name} because #{invite.errors.full_messages.first}"]
      end
    end

    render json: {
      notice: msgs.select(&:first).map(&:second),
      alert:  msgs.reject(&:first).map(&:second),
    }
  end

  def create_instructor
    name = params[:github_name]
    response = GitHubUserInfo.get_uid_from_gh(name)
    invite = UserInvite.create({
      inviter: current_user,
      github_name: name,
      role: 'instructor',
      uid: response
    })

    if invite.persisted?
      render json: { message: "Successfully invited Github account #{invite.github_name}" }, status: :ok
    else
      render json: { errors: "Could not invited Github account #{invite.github_name}" }, status: 404
    end
  end
end
