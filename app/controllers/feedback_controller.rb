require 'github_comment'

class FeedbackController < ApplicationController
  before_action :find_objects

  def new
    @feedback_template = @github.find_template(@repo)
    @student_name = @submission.student_names
  end

  def create
    if !@submission
      render :new
    else
      feedback_url = @github.add_new(params[:Feedback], @repo.repo_url, @submission.pr_id)
      if feedback_url
        @submission.update_group(feedback_url: feedback_url)
        flash[:notice] = "Feedback successfully posted"
      else
        flash[:error] = "Feedback not successfully posted"
      end

      redirect_to repo_cohort_path(@repo, @submission.student.cohort)
    end
  end

  private

  def find_objects
    @repo = Repo.find(params[:repo_id])
    @submission = Submission.find_by(student: params[:student_id], repo: @repo)
    @github = GitHubComment.new(session[:token])
  end
end
