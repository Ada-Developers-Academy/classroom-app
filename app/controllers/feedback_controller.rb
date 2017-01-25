require 'github_comment'

class FeedbackController < ApplicationController
  before_action :find_objects

  def new
    @feedback_template = GitHubComment.find_template(@repo)
    @student_name = @submission.student_names
  end

  def create
    if !@submission
      render :new
    else
      feedback_url = GitHubComment.add_new(params[:Feedback], @repo.repo_url, @submission.pr_id)
      @submission.update_group(feedback_url: feedback_url)

      redirect_to repo_cohort_path(@repo, @submission.student.cohort)
    end
  end

  private

  def find_objects
    @repo = Repo.find(params[:repo_id])
    @submission = Submission.find_by(student: params[:student_id], repo: @repo)
  end
end
