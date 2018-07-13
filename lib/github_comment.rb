require 'httparty'
require 'pr_student'

class GitHubComment
  # def get_comments()
  #   "https://api.github.com/repos/#{ repo_url }/pulls"
  #   response = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => GitHubComment::AUTH)
  #   return response
  # end

  attr_reader :token

  def initialize(token)
    @token = token
  end

  def find_template(assignment)
    url = "https://raw.githubusercontent.com/#{ assignment.repo_url }/master/feedback.md"
    response = HTTParty.get(url, headers: {"user-agent" => "rails", "Authorization" => "token #{ token }"})
    if response.code == 404
      return nil
    else
      return response
    end
  end

  def add_new(comment, repo_url, pr_id)
    url = "https://api.github.com/repos/#{ repo_url }/issues/#{ pr_id }/comments"

    response = HTTParty.post(url,
      :body => {:body => comment }.to_json,
      headers: {"user-agent" => "rails", "content-type" => "application/json", "Authorization" => "token #{ token }"})

    if response.code == 201
      feedback_url = response.parsed_response["html_url"]
      return feedback_url
    end # else return nil
  end
end
