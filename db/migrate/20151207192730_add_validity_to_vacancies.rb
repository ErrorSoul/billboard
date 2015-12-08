class AddValidityToVacancies < ActiveRecord::Migration
  def change
    add_column :vacancies, :validity, :integer
  end
end
