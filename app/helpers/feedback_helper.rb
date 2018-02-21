module FeedbackHelper
  def class_for_grade(grade)
    grade ||= :unknown

    case grade.to_sym
    when :not_standard
      'danger'
    when :approach_standard
      'warning'
    when :meet_standard
      'success'
    end
  end

  def btn_class_for_grade(grade)
    return '' unless grade

    "btn-#{class_for_grade(grade)}"
  end

  def name_for_grade(grade)
    grade ||= :unknown

    Submission.human_attribute_name("grade.#{grade}")
  end
end
