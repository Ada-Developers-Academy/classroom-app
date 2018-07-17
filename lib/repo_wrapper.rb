require 'httparty'

class RepoWrapper
  BASE_URL = "https://api.github.com/repos/Ada-C9/" #TODO: change to a variable
  KEY = ENV["GITHUB_TOKEN"]

  ALL_BASE_URL = "https://api.github.com/users/Ada-C9/repos" #TODO: change 'Ada-C9' to a variable that holds the cohort name

  def self.get_repos(assignment_repo = "")
    url = ALL_BASE_URL + assignment_repo + "?page=1&per_page=100&access_token=" + KEY #TODO: change to a variable
    response =  HTTParty.get(url)
    if response.message == "Not Found"
      raise ArgumentError.new("Invalid url: #{url}")
    else
      response.map do |result|
        self.construct_assignment(result) if !(Assignment.find_by(github_url: result["html_url"]))
      end


      # assignment = response["results"].map do |result|
      # self.construct_assignment(result)
      # end
      # return assignment
    end
  end


  def self.get_repo(assignment_repo)
    url = BASE_URL + assignment_repo + "?access_token=" + KEY
    response =  HTTParty.get(url)
    if response.message == "Not Found"
      raise ArgumentError.new("Invalid url: #{url}")
    else
      return response
      # assignment = response["results"].map do |result|
      # self.construct_assignment(result)
      # end
      # return assignment
    end
  end

  private

  def self.construct_assignment(result)

    parent_url = result["fork"] ? self.get_repo(result["name"])["parent"]["html_url"] : nil
    
    Assignment.create(
        # name: response["name"],
        repo_url: result["html_url"],
        start_date: result["created_at"],
        due_date: nil,
        individual: true
        #  add parent url to repo/assignment?
        # change individual depending on collaborators?
    )
  end

end