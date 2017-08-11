require 'test_helper'

class StudentTest < ActiveSupport::TestCase
  test "#submission_for_repo returns correct Submission" do
    [:shark_word_guess, :jet_farmar].map{|s| submissions(s)}.each do |sub|
      student = sub.student
      repo = sub.repo
      assert_equal student.submission_for_repo(repo), sub
    end
  end
end
