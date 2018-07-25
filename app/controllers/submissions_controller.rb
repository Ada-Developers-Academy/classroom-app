class SubmissionsController < ApplicationController
  load_and_authorize_resource only: [:create, :update]
  load_and_authorize_resource :student

  before_action :find_submission, only: [:show, :update]

  def index
    submissions_data = Submission.all
    render json: submissions_data, status: :ok
  end

  def show
    info_as_json("Found it")
  end


  def create
    # existing = Submission.find_by(...)

    # if existing
    #   error_as_json("Submission already exists")
    # else

      @submission = Submission.new(submission_params)

      return @submission.save ? info_as_json("Submission ##{@submission.id} created") : error_as_json(@submission.errors)
    # end
  end

  def update
    @submission.update(submission_params) ? info_as_json("Updated submission") :  error_as_json(@submission.errors)
  end

  private

  def submission_params
    params.permit(:assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id, :student_ids)
  end

  def find_submission
    @submission = Submission.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    render(
      status: :ok,
      json: @submission.as_json(only: [:id, :assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id, :student_ids]),
      message: message
    )

    # TODO: Change info_as_json this after the presentation. The frontend will have to change too to respond correctly
    # def info_as_json(message = "")
    #   render :json => {
    #     status: :ok,
    #     data: @submission.as_json(only: [:id, :assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id, :student_ids]),
    #     message: message
    #   }
    # end

  end
end