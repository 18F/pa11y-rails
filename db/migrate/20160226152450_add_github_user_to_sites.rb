class AddGithubUserToSites < ActiveRecord::Migration
  def change
    add_column :sites, :github_user, :string
    add_column :sites, :github_repo, :string
  end
end
