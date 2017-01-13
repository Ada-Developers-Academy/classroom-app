require 'httparty'
require 'pr_student'

class GitHubComment
  AUTH = { :username => ENV["GITHUB"] }
  # def get_comments()
  #   "https://api.github.com/repos/#{ repo_url }/pulls"
  #   response = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => GitHubComment::AUTH)
  #   return response
  # end

  def self.find_template(repo)
    url = "https://raw.githubusercontent.com/#{ repo.repo_url }/master/feedback.md"
    response = HTTParty.get(url, headers: {"user-agent" => "rails"}, :basic_auth => GitHubComment::AUTH)
    if response.code == 404
      return nil
    else
      return response
    end
  end

  def self.add_new(comment, repo_url, pr_id)
    url = "https://api.github.com/repos/#{ repo_url }/issues/#{ pr_id }/comments"
    # p "URLURLURL #{url} and the comment #{ comment }"
    result = HTTParty.post(url,
      :body => {:body => comment }.to_json,
      headers: {"user-agent" => "rails", "content-type" => "application/json"},
      :basic_auth => GitHubComment::AUTH)
    # p result
    if result.response["status"].include("201")
      feedback_url = result.parsed_response["html_url"]
      return feedback_url
    end # else return nil
  end
end
