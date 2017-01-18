require 'github_comment'

class FeedbackController < ApplicationController
  def new
    @repo = Repo.find(params[:repo_id])
    @feedback_template = GitHubComment.find_template(@repo)
    @submission = Submission.find_by(student: params[:student_id], repo: params[:repo_id])

    # Group or individual?
    if @repo.individual
      @student_name = Student.find(params[:student_id]).name

    else
      submission_list = @submission.find_shared
      @student_name = submission_list.map{ |sub| sub.student.name  }.join(' & ')
    end
  end

  def create
    submission = Submission.find_by(student: params[:student_id], repo: params[:repo_id])
    if !submission
      render :new
    else
        feedback_url = GitHubComment.add_new(params[:Feedback], submission.repo.repo_url, submission.pr_id)

        # Check if group
        if !Repo.find(params[:repo_id]).individual
          submission_list = submission.find_shared
        else
          submission_list = []
          submission_list << submission
        end

        # Update the submissions
        Model.transaction do
          submission_list.each do |submit|
            submit.feedback_url = feedback_url
            submit.save
          end
        end
        
        redirect_to repo_cohort_path(submit.repo, submit.student.cohort_id)
    end
  end
end
