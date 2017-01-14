require 'github_comment'

class FeedbackController < ApplicationController
  def new
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

        # Update the submission
        submit.feedback_url = feedback_url
        if submit.save
          redirect_to repo_cohort_path(submit.repo, submit.student.cohort_id)
        else
          redirect_to :back
        end

    end
  end
end
