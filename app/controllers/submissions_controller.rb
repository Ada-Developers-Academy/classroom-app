# require 'github_user_info'

class SubmissionsController < ApplicationController
  load_and_authorize_resource
  before_action :find_submission, only: [:show, :update]

  # @return :submissions list of all submissions, regardless of their active status. Sorted by ID.
  def index
    all_submissions = Submission.all
    render json: { submissions: all_submissions }, status: :ok
  end

  # @param :id
  # @return {'id', 'name', 'github_name', 'active'} if a new submission is created. Otherwise returns {'error'}.
  def show
    info_as_json
  end

  # @param must contain key :github_name, whose value is is a valid GitHub username
  # @return {'id', 'name', 'github_name', 'active'} if a new Submission is created. Otherwise returns {'error'}.
  def create
   NotImplementedError
  end

  def update
    if @submission.update(submission_params)
      info_as_json
    else
      render json: {errors: "Submission not created"}, status: :bad_request
    end
  end

  private
  #
  # t.integer "student_id", null: false
  # t.integer "assignment_id", null: false
  # t.datetime "submitted_at"
  # t.datetime "created_at", null: false
  # t.datetime "updated_at", null: false
  # t.string "pr_url"
  # t.string "feedback_url"
  # t.integer "grade"
  # t.bigint "instructor_id"

  def submission_params
    params.permit(:assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id)
  end

  def find_submission
    @submission = Submission.find_by(id: params[:id])
  end

  # QUESTION: can we refactor this out? Most/all controllers use this
  rescue_from ActiveRecord::RecordNotFound do |ex|
    render(status: :bad_request, json: { error: "#{ex}" })
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @submission.as_json(only: [:id, :name, :github_name, :active]),
        message: message
    )
  end

end