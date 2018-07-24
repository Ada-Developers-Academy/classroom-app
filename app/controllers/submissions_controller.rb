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
    uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
    existing = Instructor.find_by(uid: uid_from_gh)

    if existing
      render json: {ok: false, errors: "Instructor already exists"}, status: :bad_request
      return
    else
      @instructor = Instructor.new(
          name: params[:name] || params[:github_name],
          github_name: params[:github_name],
          uid: uid_from_gh,
          active: true
      )

      if  @instructor.save
        return info_as_json("Instructor #{@instructor.name} created")
      else
        render status: :bad_request, json: { errors: "Instructor not created"}
        return
      end
    end
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


  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @submission.as_json(only: [:id, :assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id]),
        message: message
    )
  end

end