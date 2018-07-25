require 'github'

class AssignmentsController < ApplicationController
  load_and_authorize_resource except: [:show] # TODO: Original site used this for logged-in students' "homepage". Remove?
  load_and_authorize_resource :assignment, parent: true, only: [:show] # QUESTION: ...what?
  load_and_authorize_resource :classroom, parent: false, only: [:show] # QUESTION: ...what?

  # TODO: figure this out and possibly clean up
  def index
    if params[:query]
      data = RepoWrapper.search(params[:query]) # QUESTION: ...what?
    else
      data = Assignment.all
    end
    render status: :ok, json: data
  end

  def show
    info_as_json
  end

  # TODO: make sure classroom_id, repo_url, and name are actually required
  def create
    existing = Assignment.where(classroom_id: params[:classroom_id], repo_url: params[:repo_url])
    if !existing.empty?
      return error_as_json("Assignment #{params[:repo_url]} already exists for classroom #{params[:classroom_id]}")
    end

    @assignment = Assignment.new(
        name: param[:name],
        classroom_id: param[:classroom_id],
        repo_url: param[:repo_url],
        individual: param[:individual], # TODO: check this. Original program set default to true (and still should)
    )
    @assignment.save ? info_as_json("Saved assignment #{@assignment.name}") : error_as_json(@assignment.errors)
  end

  def edit
    @max_size = Classroom.all.length # QUESTION: the fuck is @max_size??
  end

  def update
    # QUESTION: what's the difference between update_attributes and update?
    @assignment.update_attributes(assignment_params) ? info_as_json("Assignment not updated") :
        error_as_json(@assignment.errors)
  end

  private

  def find_assignment
    @assignment = Assignment.find_by(id: params[:id])
  end

  def assignment_params
    params.permit(:repo_url, :individual, :individual, :classroom_ids => [] ) # QUESTION: What's up with `=> []`
  end

  def info_as_json(message = "")
    return render(
        status: :ok,
        json: @assignment.as_json(only: [:id, :repo_url, :classroom_ids, :individual]),
        message: message
    )
  end

end
