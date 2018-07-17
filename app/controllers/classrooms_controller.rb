class ClassroomsController < ApplicationController
  load_and_authorize_resource 

  def index
    # send a list of all classrooms:
    data = Classroom.all
    render status: :ok, json: data
  end

  def show

  end

  def create
  end

  def update
  end

  def delete
  end

  def classroom_params
    params.require(:classroom).permit(:classroom_id)
  end
end
