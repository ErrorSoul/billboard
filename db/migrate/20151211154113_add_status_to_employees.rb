class AddStatusToEmployees < ActiveRecord::Migration
  def change
    add_column :employees, :status, :integer, default: 0
  end
end
