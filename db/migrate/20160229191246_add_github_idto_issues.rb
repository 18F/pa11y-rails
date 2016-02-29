class AddGithubIdtoIssues < ActiveRecord::Migration
  def change
    add_column :issues, :github_id, :text
  end
end
