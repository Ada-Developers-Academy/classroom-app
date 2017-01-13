require 'github_comment'

class FeedbackController < ApplicationController
  def new
    # Get the feedback template
    @repo = Repo.find(params[:repo_id])
    @feedback_template = GitHubComment.find_template(@repo)
    @student_name = Student.find(params[:student_id]).name
    @submission = Submission.find_by(student: params[:student_id], repo: params[:repo_id])
  end

  def create
    submit = Submission.find_by(student: params[:student_id], repo: params[:repo_id])
    if !submit
      render :new
    else
        feedback_url = GitHubComment.add_new(params[:Feedback], submit.repo.repo_url, submit.pr_id)
        p response
        # Update the submission
        # submit.feedback_url = response[:url]
        redirect_to repo_cohort_path(params[:repo_id])
    end
  end
end
