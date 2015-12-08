class CreateVacancies < ActiveRecord::Migration
  def change
    create_table :vacancies do |t|
      t.string :name
      t.string :validity
      t.string :phone
      t.string :email
      t.decimal :salary, precision: 10, scale: 2

      t.timestamps null: false
    end
  end
end
