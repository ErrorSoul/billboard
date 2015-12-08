# == Schema Information
#
# Table name: skill_items
#
#  id             :integer          not null, primary key
#  skill_id       :integer
#  skillable_id   :integer
#  skillable_type :string
#

class SkillItem < ActiveRecord::Base
  belongs_to :skill, inverse_of: :skill_items
  belongs_to :skillable, polymorphic: true
  #accepts_nested_attributes_for :skill
end
