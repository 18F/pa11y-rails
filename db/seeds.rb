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
require 'open-uri'

teamAPI = JSON.load(open("https://team-api.18f.gov/public/api/projects/"))

teamAPI["results"].each do |entry|
  if entry["links"]
    puts "Links TOP: #{entry["links"]}"
    entry["links"].each do |link|
      if link.is_a?(Hash)
        puts "Link OBJECT: #{link}"
        if link["url"].include? ".gov"
          Site.create([{
            :title => link["text"],
            :url => link["url"]
          }])
        end
      else
        puts "Link STRING: #{link}"
        if link.include? ".gov"
          Site.create([{
            :title => link,
            :url => link
          }])
        end
      end
      puts "/n"
      puts "/n"
      puts "/n"
    end
  end
end
