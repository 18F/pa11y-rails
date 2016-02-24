class AddScanToSites < ActiveRecord::Migration
  def change
    add_column :sites, :scan, :text
  end
end
