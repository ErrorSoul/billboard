module Shared
  module Relations
    extend ActiveSupport::Concern

    included do
      has_many :skill_items, as: :skillable, dependent: :destroy
      has_many :skills, through: :skill_items
    end
  end
end
