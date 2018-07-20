class CohortsController < ApplicationController
  # NOTE: commented out lined for any reason other than I copied and pasted them from somewhere else and couldn't decide
  # if we needed it or not. And then I left it because I'm a terrible partner.

  load_and_authorize_resource# except: [:show]

  # load_and_authorize_resource :assignment, parent: true, only: [:show]
  # load_and_authorize_resource :classroom, parent: false, only: [:show]

  def index
    cohorts = Cohort.all
    render status: :ok, json: cohorts
  end



  def index
    # Code for constructing internal api to be called by front-end:
    data = Cohort.all
    # data = data.paginate(page: params[:p], per_page: params[:n])
    render status: :ok, json: data
  end 

  def classroom_params
    params.require(:cohort).permit(:cohort_id)
  end

end
