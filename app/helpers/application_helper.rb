module ApplicationHelper
  def github_link(path)
    "https://github.com/#{path}"
  end

  def flash_messages(type)
    simple_format(Array(flash[type]).join("\n"))
  end
end
