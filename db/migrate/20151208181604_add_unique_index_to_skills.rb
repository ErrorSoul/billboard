class AddUniqueIndexToSkills < ActiveRecord::Migration
  def change
    add_index :skills, [:id, :name], unique: true
  end
end
