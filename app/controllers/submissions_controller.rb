# require 'github_user_info'

class SubmissionsController < ApplicationController
  load_and_authorize_resource
  before_action :find_submission, only: [:show, :update]

  def index
    submissions_data = Submission.all
    render json: submissions_data, status: :ok
  end

  def show
    info_as_json
  end

  def create
    # uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    existing = Submission.find_by(student_id: params[:student_id], assignment_id: params[:assignment_id])

    if existing
      error_as_json("Submission already exists")
    else
      @submission = Submission.new(
          assignment_id: params[:assignment_id],
          submitted_at: params[:submitted_at],
          pr_url: params[:pr_url],
          feedback_url: params[:feedback_url],
          grade: params[:grade],
          instructor_id: params[:instructor_id]
      )
      @submission.save ? info_as_json("Submission ##{@submission.id} created") : error_as_json(@submission.errors)
    end
  end

  def update
    @submission.update(submission_params) ? info_as_json("Updated submission") :  error_as_json(@submission.errors)
  end

  private

  def submission_params
    params.permit(:assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id)
  end

  def find_submission
    @submission = Submission.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @submission.as_json(only: [:id, :assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id]),
        message: message
    )
  end

end