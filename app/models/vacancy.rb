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
  include Shared::Scopes
  include Shared::Relations
  include Shared::Helpers
  include Shared::SQL

  after_save :to_public

  validates :name, :validity, presence: true
  validates :published_at, :state, presence: true
  validates :name, length: { in: 2..140 }
  validates :validity, numericality: { greater_than_or_equal_to: 0 }

  #
  # Scopes
  #

  scope :salary_ord, -> { order salary: :desc }
  scope :to_show, -> { where state: :published }


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
