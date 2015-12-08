class CreateSkillItems < ActiveRecord::Migration
  def change
    create_table :skill_items do |t|
      t.belongs_to :skill, index: true
      t.references :skillable, polymorphic: true, index: true

    end
    add_foreign_key :skill_items, :skills
  end
end
