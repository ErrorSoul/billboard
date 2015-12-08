class RemoveTimestampsFromSkills < ActiveRecord::Migration
  def change
    remove_column :skills, :created_at, :string
    remove_column :skills, :updated_at, :string
  end
end
