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

FactoryGirl.define do
  sequence(:email) { |n| "example#{ n }@mail.com" }
  sequence(:phone) { |n| "+7(#{ n < 100 ? 100 + n : n })227-22-76" }
  sequence(:salary) { |n| 10000 + (500 * n) }
  factory :vacancy do
    name 'Super Job'
    email
    phone
    validity 5
    salary
    published_at { DateTime.now }
    state :unpublished

    trait :published do
      state :published
    end

    trait :unpublised do
      state :unpublised
    end

    trait :in_the_past do
      published_at { 6.days.ago }
    end

    trait :validity_equal do
      validity 6
    end

    trait :validity_unpublished do
      validity 5
    end

    trait :validity_published do
      validity 10
    end

    trait :zero_salary do
      salary 0
    end

    trait :wrong_salary do
      salary 'adfasdf'
    end

    trait :negative_salary do
      salary -1000
    end

    trait :no_email do
      email ''
    end

  end
end
