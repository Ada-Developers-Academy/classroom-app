require 'github'

class AssignmentsController < ApplicationController
  load_and_authorize_resource except: [:show]
  load_and_authorize_resource :assignment, parent: true, only: [:show]
  load_and_authorize_resource :classroom, parent: false, only: [:show]

  def index
    if params[:query]
      data = RepoWrapper.search(params[:query]) # QUESTION: ...what?
    else
      data = Assignment.all
    end
    render status: :ok, json: data
  end

  def show
    # original code for views:
    gh = GitHub.new(session[:token])

    @all_data = gh.retrieve_student_info(@assignment, @cohort)

    render(
      status: :ok,
      json: @assignment.as_json(
        only: [:id, :repo_url]
      )
    )
    # Should we change this?
  end

  def create
    if @assignment.save
      info_as_json("Saved assignment #{@assignment.name}")
    else
      render status: :bad_request, json: { errors: "Assignment not created"}
    end
  end

  def edit
    @max_size = Classroom.all.length # QUESTION: the fuck is @max_size??
  end

  def update
    if @assignment.update_attributes(assignment_params)
      @assignment.classrooms.build # QUESTION: ...what?? 😩
      redirect_to assignments_path
    else
      render status: :bad_request, json: { errors: "Assignment not updated"}
    end
  end

  def destroy
    NotImplementedError
    # @assignment.destroy
    # render status: :ok, json: { errors: "Assignment deleted"}
  end

  private

  def find_assignment
    @assignment = Assignment.find_by(id: params[:id])
  end

  def assignment_params
    params.require(:assignment).permit(:repo_url, :individual, :classroom_ids => [] ) # QUESTION: What's up with `=> []`
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @instructor.as_json(only: [:id, :repo_url, :classroom_ids]),
        message: message
    )
  end

end
