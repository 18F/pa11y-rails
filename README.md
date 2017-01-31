# pa11y-rails
A rails app that tracks 18f's various app's accessibility using the pa11y CLI tool. 

## Setup
1. Install [pa11y](https://github.com/springernature/pa11y)
2. Install Ruby 2.3.3 with your ruby manager of choice
3. Install bundler `gem install bundler`
4. Run `bundle install`
5. Install postgres
6. Setup database, this also runs scans. `rake db:setup`
* note: You may see `hashie` warnings. These can be ignored
7. Start rails `bundle exec rails server`

