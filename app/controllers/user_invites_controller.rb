require 'github_user_info'

class UserInvitesController < ApplicationController
  load_and_authorize_resource instance_name: :invite

  # @return :invites list of all invites
  def index
    # acceptable_invites = @invites.acceptable  # QUESTION: why did they originally have it as '@invites.acceptable'?
    all_invites = UserInvite.all
    render json: { invites: all_invites }, status: :ok
  end

  def new_student; end # QUESTION: What's up with this? Are the just to make the routes happy?
  def new_instructor; end


  # @return :errors if there was a problem creating
  def create   # TODO: tell Leti about this because it's fancy as fuck
    action = :"create_#{params[:role]}"
    return send(action) if respond_to?(action, true) # NOTE: calls create_student or instructor (see below)

    render json: { errors: "Could not create" }, status: bad_request
  end

  private

  def user_invite_params
    params.permit(:inviter, :github_name, :role, :classroom_id, :uid)
  end

  # TODO: clear up repeated code in create_student and create_instructor and put it here
  def create_helper
  end

  # @param :github_names must be a String of valid, unique Github username separated by a tab, end of line, or new line
  # @param :classroom_id much be a valid classroom id
  def create_student
    github_names = params[:github_names].split(/[ \t\r\n]+/).map(&:strip).uniq
    classroom = Classroom.find_by(id: params[:classroom_id])

    return error_as_json("Could not find classroom with ID #{params[:classroom_id]}") if !classroom.present?

    msgs = github_names.map do |name|
      github_uid = GitHubUserInfo.get_uid_from_gh(name)
      invite = UserInvite.new({
        inviter: current_user,
        github_name: name,
        role: 'student',
        classroom_id: params[:classroom_id],
        uid: github_uid
      })

      if invite.save # QUESTION: what is this?
        [true, "Successfully invited Github account #{name}"]
      else
        [false, "Could not invited Github account #{name} because #{invite.errors.full_messages.first}"]
      end
    end

    # TODO: love how clean this is but make this consistent with the formatting of the rest of the messages
    render json: {
      notice: msgs.select(&:first).map(&:second),
      alert:  msgs.reject(&:first).map(&:second),
    }
  end

  # @param :github_name must be a valid GitHub name (note this is singular)
  def create_instructor
    name = params[:github_name]
    response = GitHubUserInfo.get_uid_from_gh(name)
    invite = UserInvite.new({
      inviter: current_user,
      github_name: name,
      role: 'instructor',
      uid: response
    })

    if invite.save
      render json: { message: "Successfully invited Github account #{invite.github_name}" }, status: :ok
    else
      error_as_json(invite.errors)
    end
  end
end
