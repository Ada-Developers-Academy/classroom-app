require 'schoology'

class AttendanceController < ApplicationController
  # skip_before_action :require_login, only: [:home]

  def index
    @courses = Schoology.retrieve_courses(session[:schoology_token], session[:schoology_secret])
    raise
  end
end
