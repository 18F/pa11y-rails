class AddErrorReportsToPages < ActiveRecord::Migration
  def change
    add_column :pages, :acc_warnings, :integer
    add_column :pages, :acc_errors, :integer
    add_column :pages, :acc_notices, :integer
    add_column :pages, :scan, :text
  end
end
