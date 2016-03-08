class Pa11yIssue < ActiveRecord::Base
  belongs_to :page
  def self.type_summary
    issue_types = {}
    self.where(issue_type: 'error').find_each do |issue|
      if issue_types[issue.code]
        issue_types[issue.code][:value] += 1
      else
        issue_types[issue.code] = {value: 1, description: issue.description}
      end
    end
    issues_array = []
    issue_types.each do |attr_name, attr_value|
      issues_array.push({name: attr_name, value: attr_value[:value], description: attr_value[:description]})
    end
    issues_array.sort {|a,b| b[:value] <=> a[:value]}
  end

  def markdown_description
    "* __#{self.issue_type.humanize}__ #{self.description}\n * #{self.code}\n * `#{self.css}`\n * `#{self.element}`"
  end
end
