class AddPageCountToSites < ActiveRecord::Migration
  def change
    add_column :sites, :pages_count, :integer
  end
end
