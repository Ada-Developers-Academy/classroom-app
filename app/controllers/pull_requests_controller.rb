# require 'httparty'

class PullRequestsController < ApplicationController
  skip_before_action :require_login, only: [:home]
  skip_authorization_check only: [:home]
  # QUESTION: what's this "instance_name: :assignment" thing about and why does Charles gotta be so fancy?
  load_and_authorize_resource class: Assignment, instance_name: :assignment, except: [:home]

  def home
    if can? :read, Assignment
      data = Assignment.all
      render status: :ok, json: data
      # redirect_to pull_requests_path
    elsif can? :read, Student
      students = Student.accessible_by(current_ability)

      redirect_to students.first if students.length == 1
      redirect_to students_path if students.length > 1
    elsif can? :read, Instructor
      instructors = Instructor.accessible_by(current_ability)
      #
      # redirect_to students.first if students.length == 1
      redirect_to instructors_path #if students.length > 1
    end

  end

  def index
  end

end
