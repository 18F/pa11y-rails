class CreateIssues < ActiveRecord::Migration
  def change
    create_table :issues do |t|
      t.string :url
      t.string :title
      t.references :site, index: true

      t.timestamps null: false
    end
    add_foreign_key :issues, :sites
  end
end
