class AddPagesCountToSites < ActiveRecord::Migration
  def change
    add_column :sites, :acc_errors_fixed, :integer
    add_column :sites, :pages_count, :integer
  end
end
