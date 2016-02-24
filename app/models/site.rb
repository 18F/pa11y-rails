class Site < ActiveRecord::Base
  validates :title, presence: true,
                    length: { minimum: 1 }
  validates :url, presence: true,
                    length: { minimum: 3 }
  before_save :run_scan

  def update_scan time=5000
    if Time.now - self.updated_at > time
      self.save
    end
  end

  def error_report
    %x(pa11y #{self.url} --reporter markdown --ignore "warning;notice")
  end

  def run_scan
    puts self.url
    scan_url = "pa11y #{self.url} --reporter html"
    puts "Scan Url: #{scan_url}"
    self.scan = %x(#{scan_url})

    json_url = "pa11y #{self.url} --reporter json"
    json_string = %x(#{json_url})
    # puts json_string
    
    # binding.pry
    self.acc_errors = 0
    self.acc_notices = 0
    self.acc_warnings = 0
    puts "Parsing JSON"
    begin
      json_hash = JSON.parse(json_string)
      puts "JSON Hash=: #{json_hash}"
      json_hash.each do |key, array|
        case key["type"]
        when "error"
          self.increment(:acc_errors, by = 1)
        when "notice"
          self.increment(:acc_notices, by = 1)
        when "warning"
          self.increment(:acc_warnings, by = 1)
        end
      end
    rescue JSON::ParserError => e
    end

  end

end
