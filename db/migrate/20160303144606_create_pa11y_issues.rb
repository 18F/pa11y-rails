class CreatePa11yIssues < ActiveRecord::Migration
  def change
    create_table :pa11y_issues do |t|
      t.references :page, index: true
      t.text :description
      t.string :code
      t.string :css
      t.text :element
      t.string :issue_type
      t.boolean :ignore
      t.boolean :fixed

      t.timestamps null: false
    end
    add_foreign_key :pa11y_issues, :pages
  end
end
