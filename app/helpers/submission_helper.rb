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

  def feedback_provider(submission)
    if submission.feedback_provider
      submission.feedback_provider.name
    elsif submission.feedback_url
      "Unknown"
    end
  end
end
