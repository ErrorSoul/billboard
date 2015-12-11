# == Schema Information
#
# Table name: skills
#
#  id   :integer          not null, primary key
#  name :string
#

class Skill < ActiveRecord::Base

  validates :name, presence: true
  validates :name, length: { in: 2..140 }
  validates :name, uniqueness: true

  has_many :skill_items, inverse_of: :skill

  before_save { self.name = name.downcase }

  default_scope { order id: :asc }

  def self.find_or_create_(name)
    begin
      self.find_or_create_by(name: name)
    rescue ActiveRecord::RecordNotUnique
      retry
    end
  end
end
