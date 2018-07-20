class GitHubUserInfo

  def self.get_name_and_uid_from_gh(github_username)
    response =  HTTParty.get('https://api.github.com/users/' + github_username)
    if response.message == "ok"
      return {
        uid: response.data["id"],
        name: response.data["name"]
      }
    else
      return { error: response.message } # TODO: does this actually work?
    end
  end

  def self.get_uid_from_gh(github_username)
    response =  HTTParty.get('https://api.github.com/users/' + github_username)
    return response["id"] #if response.respond_to? "id"
  end

end
  # attr_accessor :github, :pr_created, :pr_url, :student_model

#   def initialize(*args)
#     @student_model = args.first
#     if args.length > 1
#       @github = args[1]
#       @pr_created = args[2]
#       @pr_url = args[3]
#     end
#   end
# end
