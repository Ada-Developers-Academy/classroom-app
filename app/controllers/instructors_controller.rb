class InstructorsController < ApplicationController
  load_and_authorize_resource
  # NOTE: commented out lined for any reason other than I copied and pasted them from somewhere else and couldn't decide
  # if we needed it or not. And then I left it because I'm a terrible partner.
  # load_and_authorize_resource except: [:show]
  # load_and_authorize_resource :assignment, parent: true, only: [:show]
  # load_and_authorize_resource :classroom, parent: false, only: [:show]

  def index
    instructors = Instructor.where(active: true)
    render status: :ok, json: instructors
  end

  # TODO: probably fucked this up and need to check it
  # def create
  #   if @instructor.save
  #     render status: :ok, json: @instructor.data
  #   else
  #     render :bad_request, :status => :bad_request # for sure not right
  #   end
  # end


end
