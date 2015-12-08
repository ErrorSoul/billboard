module Shared
  module Validation
    extend ActiveSupport::Concern

    included do
      VALID_PHONE_REGEXP = /^((8|\+7|7)-?)?\(?\d{3}\)?-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}-?\d{1}$/
      VALID_EMAIL_REGEXP = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i

      validates :phone, presence: true,
        format: { with: VALID_PHONE_REGEXP, multiline: true }
      validates :phone, uniqueness: true

      validates :email, presence: true,
        format: { with: VALID_EMAIL_REGEXP, multiline: true }
      validates :email, uniqueness: true

      before_save { self.email = email.downcase }
    end
  end
end
