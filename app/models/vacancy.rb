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
#

class Vacancy < ActiveRecord::Base

  include Shared::Validation

  after_save :to_public

  validates :name, :validity, :salary, presence: true
  validates :published_at, :state, presence: true
  validates :name, length: { in: 3..140 }
  validates :salary, numericality: { greater_than_or_equal_to: 0 }
  validates :validity, numericality: { greater_than_or_equal_to: 0 }

  state_machine :state, initial: :unpublished do

    event :published  do
      transition unpublished: :published
    end

    event :unpublished do
      transition published: :unpublished
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
