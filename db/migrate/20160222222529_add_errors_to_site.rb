class AddErrorsToSite < ActiveRecord::Migration
  def change
    add_column :sites, :acc_warnings, :integer
    add_column :sites, :acc_errors, :integer
    add_column :sites, :acc_notices, :integer
  end
end
