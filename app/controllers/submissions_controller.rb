class SubmissionsController < ApplicationController
  load_and_authorize_resource :except => :create
  load_and_authorize_resource :student#, only: [:create, :update] # need due to many-to-many relationship
  before_action :find_submission, only: [:show, :update]

  def index
    submissions_data = Submission.order(:submitted_at).collect { |submission|
      @submission = submission
      info_as_json }
    render json: submissions_data, status: :ok
  end

  def show
    info_as_json
  end

  def create
    # existing = Submission.find_by(...)

    # if existing
    #   error_as_json("Submission already exists")
    # else
    @submission = Submission.new(submission_params)
    @submission.save ? info_as_json("Submission ##{@submission.id} created") : error_as_json(@submission.errors)
    # end
  end

  def update
    @submission.update(submission_params) ? info_as_json("Updated submission") :  error_as_json(@submission.errors)
  end

  private

  def submission_params
    params.permit(:assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id, student_ids: [])
  end

  def find_submission
    @submission = Submission.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    return {
      status: :ok,
      data: { raw:  @submission.as_json(only: [:id, :assignment_id, :submitted_at, :pr_url, :grade,
                                       :instructor_id, :student_ids]),
      display_data: {
          instructor_name: @submission.feedback_provider.name,
          student_name: @submission.students.collect { |student| student.name },
          due_date: @submission.assignment.due_date.strftime("%B %d, %Y"),
          submission_date: @submission.submitted_at.strftime("%B %d, %Y"),
          assignment_name: @submission.assignment.name,
          feedback_form_url: @submission.get_pr_feedback
      }},
      message: message
    }
  end


end