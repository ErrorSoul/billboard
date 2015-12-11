class RemoveStatusFromEmployees < ActiveRecord::Migration
  def change
    remove_column :employees, :status, :string
  end
end
