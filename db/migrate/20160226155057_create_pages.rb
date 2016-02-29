class CreatePages < ActiveRecord::Migration
  def change
    create_table :pages do |t|
      t.string :url
      t.string :title
      t.references :site, index: true

      t.timestamps null: false
    end
    add_foreign_key :pages, :sites
  end
end
