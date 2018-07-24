class GitHubUserInfo

  # FIXME: broken af?
  # def self.get_name_and_uid_from_gh(github_username)
  #   response =  HTTParty.get('https://api.github.com/users/' + github_username)
  #   if response.message == "ok"
  #     return {
  #       uid: response.data["id"],
  #       name: response.data["name"]
  #     }
  #   else
  #     return { error: response.message } # TODO: does this actually work?
  #   end
  # end

  def self.get_uid_from_gh(github_username)
    response =  HTTParty.get('https://api.github.com/users/' + github_username)
    return response["id"] #if response.respond_to? "id"
  end

end
