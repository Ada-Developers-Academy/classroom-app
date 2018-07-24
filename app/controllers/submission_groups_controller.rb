# # require 'github_user_info'
#
# class SubmissionGroupsController < ApplicationController
#   load_and_authorize_resource
#   before_action :find_submission_group, only: [:show, :update]
#
#   # @return :submissions list of all submissions, regardless of their active status. Sorted by ID.
#   def index
#     all_submission_groups = SubmissionGroup.all
#     render json: { submission_groups: all_submission_groups }, status: :ok
#   end
#
#   # @param :id
#   # @return {'id', 'name', 'github_name', 'active'} if a new submission is created. Otherwise returns {'error'}.
#   def show
#     info_as_json
#   end
#
#   # @param must contain key :github_name, whose value is is a valid GitHub username
#   # @return {'id', 'name', 'github_name', 'active'} if a new Submission is created. Otherwise returns {'error'}.
#   def create
#     # uid_from_gh = GitHubUserInfo.get_uid_from_gh(params[:github_name])
#     # existing = Instructor.find_by(uid: uid_from_gh)
#
#     if existing
#       render json: {ok: false, errors: "Instructor already exists"}, status: :bad_request
#       return
#     else
#       @instructor = Instructor.new(
#           name: params[:name] || params[:github_name],
#           github_name: params[:github_name],
#           uid: uid_from_gh,
#           active: true
#       )
#
#       if  @instructor.save
#         return info_as_json("Instructor #{@instructor.name} created")
#       else
#         render status: :bad_request, json: { errors: "Instructor not created"}
#         return
#       end
#     end
#   end
#
#   def update
#     if @submission_group.update(submission_group_params)
#       info_as_json
#     else
#       render json: {errors: "Submission not created"}, status: :bad_request
#     end
#   end
#
#   private
#
#   def submission_group_params
#     params.permit(:assignment_id, :submitted_at, :pr_url, :feedback_url, :grade, :instructor_id)
#   end
#
#   def find_submission_group
#     @submission_group = SubmissionGroup.find_by(id: params[:id])
#   end
#
#   # QUESTION: can we refactor this out? Most/all controllers use this
#   rescue_from ActiveRecord::RecordNotFound do |ex|
#     render(status: :bad_request, json: { error: "#{ex}" })
#   end
#
#   def info_as_json(message = "")
#     return render(
#         status: :ok,
#         json: @submission_group.as_json(only: [
#             :id,
#             :assignment_id,
#             :submitted_at,
#             :pr_url,
#             :feedback_url,
#             :grade,
#             :instructor_id
#         ]),
#         message: message
#     )
#   end
#
# end