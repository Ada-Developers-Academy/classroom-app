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

  def create
    action = :"create_#{params[:role]}"
    return send(action) if respond_to?(action, true)

    render not_found
  end

  private

  def create_student
    github_names = params[:github_names].split(/[ \t\r\n]+/).map(&:strip).uniq
    cohort = Cohort.find_by(id: params[:cohort_id])
    if !cohort.present?
      return redirect_to user_invites_path,
                         alert: "Could not find cohort with ID #{params[:cohort_id]}"
    end

    msgs = github_names.map do |name|
      invite = UserInvite.create({
        inviter: current_user,
        github_name: name,
        role: 'student',
        cohort: cohort
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
