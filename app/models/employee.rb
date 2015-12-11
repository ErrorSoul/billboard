# == Schema Information
#
# Table name: employees
#
#  id          :integer          not null, primary key
#  first_name  :string
#  middle_name :string
#  last_name   :string
#  email       :string
#  phone       :string
#  salary      :decimal(10, 2)
#  created_at  :datetime         not null
#  updated_at  :datetime         not null
#  status      :integer          default(0)
#

class Employee < ActiveRecord::Base

  include Shared::Validation
  include Shared::Scopes
  include Shared::Relations
  include Shared::Helpers
  include Shared::SQL

  enum status: [ :search, :stop ]
  validates :first_name, :middle_name, :last_name, presence: true
  validates :status, presence: true
  validates :first_name, :middle_name, :last_name,
    length: { in: 2..140 }

  validates_each :first_name, :middle_name, :last_name do |record, attr, value|
    record.errors.add attr, 'should be cyrillic' if !cyrillic?(value)
  end

  scope :salary_ord, -> { order salary: :asc }
  scope :to_show, -> { where status: 0 }

  private

  def self.cyrillic?(value)
    value =~ /^((\s)*(\p{Cyrillic})+(\s)*)+$/
  end

end
