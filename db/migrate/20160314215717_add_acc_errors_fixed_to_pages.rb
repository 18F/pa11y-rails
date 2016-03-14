class AddAccErrorsFixedToPages < ActiveRecord::Migration
  def change
    add_column :pages, :acc_errors_fixed, :integer
  end
end
