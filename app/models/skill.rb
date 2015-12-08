# == Schema Information
#
# Table name: skills
#
#  id   :integer          not null, primary key
#  name :string
#

class Skill < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { in: 3..140 }
  validates :name, uniqueness: true

  has_many :skill_items, inverse_of: :skill

  def self.find_or_create_(name)
    begin
      self.find_or_create_by(name: name)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
