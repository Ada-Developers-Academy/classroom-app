class CohortsController < ApplicationController
  load_and_authorize_resource
  before_action :find_cohort, only: [:show, :update]

  def index
    all_cohorts = Cohort.all
    render status: :ok, json: all_cohorts
  end

  def show
    info_as_json
  end

  def create
    existing = Cohort.find_by(id: params[:id]) # TODO: why am I doing this?
    if existing
      return error_as_json("Cohort already exists")
    else
      @cohort = Cohort.new(cohort_params)
      @cohort.save ? info_as_json("New cohort #{@cohort.name} created") : error_as_json(@cohort.errors)
    end
  end

  def update
    @cohort.update(cohort_params) ? info_as_json("Cohort #{@cohort.name} updated") : error_as_json(@cohort.errors)
  end

  private

  def cohort_params
    params.permit(:id, :number, :name, :repo_name, :class_start_date, :class_end_date,
                  :internship_start_date, :internship_end_date, :graduation_date)
  end

  def find_cohort
    @cohort = Cohort.find_by(id: params[:id])
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @cohort.as_json(only: [:id, :number, :name, :repo_name, :class_start_date, :class_end_date,
                                     :internship_start_date, :internship_end_date, :graduation_date]),
        message: message
    )
  end

  # TODO: Change info_as_json this after the presentation. The frontend will have to change too to respond correctly
  # def info_as_json(message = "")
  #   render :json => {
  #     status: :ok,
  #     data: @cohort.as_json(only: [:id, :number, :name, :repo_name, :class_start_date, :class_end_date,
  #                                      :internship_start_date, :internship_end_date, :graduation_date]),
  #     message: message
  #   }
  # end

end
