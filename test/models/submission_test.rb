require 'test_helper'

class SubmissionTest < ActiveSupport::TestCase
  class Validations < SubmissionTest
    def valid_submission
      submissions(:jet_farmar)
    end

    setup do
      # puts submissions(:jet_farmar).inspect
      # sanity check
      assert valid_submission.valid?
    end

    test 'validates grade can be nil when feedback has not been submitted' do
      valid_submission.grade = nil
      valid_submission.feedback_url = nil
      valid_submission.feedback_provider = nil

      assert valid_submission.valid?
    end
  end
end
