require 'github_comment'

# QUESTION: literally everything going on here
class FeedbackController < ApplicationController
  before_action :find_objects
  before_action :authorize!

  def new
    @feedback_template = @github.find_template(@assignment)
    @student_name = @submission.student_names
  end

  def create
    if !@submission
      render :new
    else
      feedback_url = @github.add_new(feedback_params[:comments], @assignment.repo_url, @submission.pr_id)
      if feedback_url
        @submission.update_group(feedback_url: feedback_url, user_id: session[:user_id], grade: feedback_params[:grade])
        flash[:notice] = "Feedback successfully posted"
      else
        flash[:error] = "Feedback not successfully posted"
      end

      redirect_to repo_classroom_path(@assignment, @submission.student.classroom)
    end
  end

  private

  def find_objects
    @assignment = Assignment.find(params[:assignment_id])
    @submission = Submission.find_by(student: params[:student_id], assignment: @assignment)
    @github = GitHubComment.new(session[:token])
  end

  def authorize!
    super :create, @submission
  end

  def feedback_params
    params.require(:feedback).permit(:comments, :grade)
  end
end
