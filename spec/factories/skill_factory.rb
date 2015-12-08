# == Schema Information
#
# Table name: skills
#
#  id   :integer          not null, primary key
#  name :string
#

FactoryGirl.define do
  sequence(:name) { |n| "Skill##{ n }" }

  factory :skill do
    name
  end
end
