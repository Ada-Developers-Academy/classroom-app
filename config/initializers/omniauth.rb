require "#{ Rails.root }/lib/schoology_strategy"

Rails.application.config.middleware.use OmniAuth::Builder do
  provider :github, ENV["GITHUB_CLIENT_ID"], ENV["GITHUB_CLIENT_SECRET"], scope: "user,repo"

  provider :schoology, ENV["SCHOOLOGY_CONSUMER_KEY"], ENV["SCHOOLOGY_CONSUMER_SECRET"]
end
