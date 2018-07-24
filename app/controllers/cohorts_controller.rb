class CohortsController < ApplicationController
  load_and_authorize_resource
  before_action :find_cohort, only: [:show, :update]

  def index
    data = Cohort.all
    render status: :ok, json: data
  end

  def show
    info_as_json
  end

  # @param :number
  # @param :name
  # @param :repo_name *required*
  # @param :class_start_date
  # @param :class_end_date
  # @param :internship_start_date
  # @param :internship_end_date
  # @param :graduation_date
  def create
    # Does not use find_cohort
    existing = Cohort.find_by(id: params[:id])

    if existing
      render json: { errors: "Cohort already exists"}, status: :bad_request
    else
      @cohort = Cohort.new(
          number: params[:number],
          name: params[:name],
          repo_name: params[:repo_name],
          class_start_date: params[:class_start_date],
          class_end_date: params[:class_end_date],
          internship_start_date: params[:internship_start_date],
          internship_end_date: params[:internship_end_date],
          graduation_date: params[:graduation_date]
      )

      if @cohort.save
        info_as_json("New cohort #{@cohort.name} created")
      else
        render json: { errors: "New cohort not created"}, status: :bad_request
      end

    end
  end

  def update
    if @cohort.update(cohort_params)
      info_as_json("Cohort #{@cohort.name} updated")
    else
      render json: {errors: "Cohort not updated"}, status: :bad_request
    end
  end

  private
  def cohort_params
    params.require(:cohort).permit(:id, :number, :name, :repo_name, :class_start_date, :class_end_date,
                                   :internship_start_date, :internship_end_date, :graduation_date)
  end

  def find_cohort
    @cohort = Cohort.find_by(id: params[:id])
  end

  # QUESTION: can we refactor this out? Most/all controllers use this
  # rescue_from ActiveRecord::RecordNotFound do |ex|
  #   render(status: :bad_request,
  #          json: { error: "#{ex}" }
  #   )
  # end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @cohort.as_json(only: [:id, :number, :name, :repo_name, :class_start_date, :class_end_date,
                                     :internship_start_date, :internship_end_date, :graduation_date]),
        message: message
    )
  end

end
