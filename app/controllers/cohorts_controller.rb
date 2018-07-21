class CohortsController < ApplicationController
  load_and_authorize_resource

  def index
    data = Cohort.all
    render status: :ok, json: data
  end

  def new

  end

  # @param :number
  # @param :name
  # @param :repo_name required
  # @param :class_start_date
  # @param :class_end_date
  # @param :internship_start_date
  # @param :internship_end_date
  # @param :graduation_date
  def create
    existing = Cohort.find_by(id: params[:id])

    if existing
      render json: { errors: "Cohort already exists"}, status: :bad_request
    else
      new_cohort = Cohort.new(
          number: params[:number],
          name: params[:name],
          repo_name: params[:repo_name],
          class_start_date: params[:class_start_date],
          class_end_date: params[:class_end_date],
          internship_start_date: params[:internship_start_date],
          internship_end_date: params[:internship_end_date],
          graduation_date: params[:graduation_date]
      )

      if new_cohort.save
        render json: { message: "New cohort #{new_cohort.name} created!" }, status: :ok
      else
        render json: { errors: "New cohort not created"}, status: :bad_request
      end

    end
  end

  private
  def cohort_params
    params.require(:cohort).permit(:number, :name, :repo_name, :class_start_date, :class_end_date,
                                   :internship_start_date, :internship_end_date, :graduation_date)
  end

end
