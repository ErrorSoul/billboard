class AddIndexToSkills < ActiveRecord::Migration
  def change
    add_index :skills, :name
  end
end
