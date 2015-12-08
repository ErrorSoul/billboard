class AddStateToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :state, :string
  end
end
