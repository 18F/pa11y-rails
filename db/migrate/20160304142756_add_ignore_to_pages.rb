class AddIgnoreToPages < ActiveRecord::Migration
  def change
    add_column :pages, :acc_ignore, :integer
  end
end
