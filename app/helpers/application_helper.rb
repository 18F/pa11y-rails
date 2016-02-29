module ApplicationHelper
  Github.configure do |c|
    c.oauth_token = ENV["GITHUB_OAUTH"]
    c.user = ENV["GITHUB_USER"]
  end
end
