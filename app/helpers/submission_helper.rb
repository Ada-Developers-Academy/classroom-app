module SubmissionHelper
  def style_type(submission)
    if !submission.pr_url
      return 'danger'
    elsif !submission.feedback_url
      return 'warning'
    else
      return 'success'
    end
  end
end
