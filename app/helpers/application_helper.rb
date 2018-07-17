module ApplicationHelper
  def github_link(path)
    "https://github.com/#{path}"
  end

  def flash_messages(type)
    simple_format(Array(flash[type]).join("\n"))
  end

  #
  def get_uid_from_github(github_username)
  end
end
