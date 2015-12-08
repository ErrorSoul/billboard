class AddIndexToVacancies < ActiveRecord::Migration
  def change
    add_index :vacancies, :email
    add_index :vacancies, :phone
  end
end
