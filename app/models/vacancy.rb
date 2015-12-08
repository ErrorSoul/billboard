# == Schema Information
#
# Table name: vacancies
#
#  id           :integer          not null, primary key
#  name         :string
#  phone        :string
#  email        :string
#  salary       :decimal(10, 2)
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#  published_at :datetime
#  validity     :integer
#  state        :string
#

class Vacancy < ActiveRecord::Base

  include Shared::Validation

  after_save :to_public

  validates :name, :validity, :salary, presence: true
  validates :published_at, :state, presence: true
  validates :name, length: { in: 3..140 }
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
  validates :validity, numericality: { greater_than_or_equal_to: 0 }

  has_many :skill_items, as: :skillable, dependent: :destroy
  has_many :skills, through: :skill_items
  accepts_nested_attributes_for :skill_items, allow_destroy: true
  accepts_nested_attributes_for :skills, allow_destroy: true

  state_machine :state, initial: :unpublished do

    event :published  do
      transition unpublished: :published
    end

    event :unpublished do
      transition published: :unpublished
    end
  end

  def all_skills=(skills)
    skills_array = skills.map do |s|
      Skill.find_or_create_by!(name: s.name)
    end.uniq

    skill_items.destroy_all

    skills_array.each do |skill|
      skill_items.create!(skill_id: skill.id)
    end
  end

  private

  def check_published?
    published_at + validity.days > DateTime.now
  end

  def to_public
    check_published? ? published : unpublished
  end
end
