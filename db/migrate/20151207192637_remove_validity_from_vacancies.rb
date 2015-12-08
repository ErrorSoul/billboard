class RemoveValidityFromVacancies < ActiveRecord::Migration
  def change
    remove_column :vacancies, :validity, :string
  end
end
