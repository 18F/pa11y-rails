class CreateOrgs < ActiveRecord::Migration
  def change
    create_table :orgs do |t|
      t.string :title
      t.string :github_user

      t.timestamps null: false
    end
  end
end
