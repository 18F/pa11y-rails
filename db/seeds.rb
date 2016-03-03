# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

# Site.create([
#     {:title => "18F - Homepage", :url=>"18f.gov"},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#     {:title => "", :url=>""},
#   ])
# require 'open-uri'

# teamAPI = JSON.load(open("https://team-api.18f.gov/public/api/projects/"))

# teamAPI["results"].each do |entry|
#   Site.create([{
#     :title => entry['name']
#   }])
#   site = Site.last
#   if entry["github"]
#     if entry["github"].is_a?(Hash)
#       puts entry["github"]
#       github = entry["github"]["name"].split('/')
#     else
#       github = entry["github"].first.split('/')
#     end
#     site.github_user = github.first
#     site.github_repo = github.second
#     site.save
#   end
#   if entry["links"]
#     entry["links"].each do |link|
#       if link.is_a?(Hash)
#         puts "Link OBJECT: #{link}"
#         if link["url"].include? ".gov"
#           site.pages.create([{
#             :title => link["text"],
#             :url => link["url"]
#           }])
#         end
#       elsif link.include? ".gov"
#           site.pages.create([{
#             :title => link,
#             :url => link
#           }])
#       end
#     end
#   end
# end
# require 'Github'


#skip these URL's
skip = ['https://blogalytics.18f.gov']
Github.configure do |c|
  c.oauth_token = ENV["GITHUB_OAUTH"]
  c.user = ENV["GITHUB_USER"]
end
github = Github.new
repos = github.repos.list user:"18f", auto_pagination: true

repos.body.each do |repo|
  puts repo.name
  puts repo.homepage
end
repos.body.each do |repo|
  puts repo.homepage
  if repo.homepage && repo.homepage.include?(".gov") && !skip.include?(repo.homepage)
    site = Site.create({
      title: repo.name,
      github_repo: repo.name,
      github_user: '18f'})
    sleep(0.25)
    site.pages.create({
      title: repo.homepage,
      url: repo.homepage
      })
  end
end