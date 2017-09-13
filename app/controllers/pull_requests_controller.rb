# require 'httparty'

class PullRequestsController < ApplicationController
  skip_before_action :require_login, only: [:home]
  skip_authorization_check only: [:home]
  load_and_authorize_resource class: Repo, instance_name: :repo, except: [:home]

  def home
    if can? :read, Repo
      redirect_to pull_requests_path
    elsif can? :read, Student
      students = Student.accessible_by(current_ability)

      redirect_to students.first if students.length == 1
      redirect_to students_path if students.length > 1
    end
  end

  def index
  end

end
