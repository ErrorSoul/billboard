# -*- coding: utf-8 -*-
FactoryGirl.define do
   factory :employee do
    first_name 'Работник'
    middle_name 'Работникович'
    last_name 'Работников'
    email
    phone
    salary 10000

    trait :searched do
      status :search
    end

    trait :stoped do
      status :stop
    end

    trait :first_name do
      first_name 'Работник'
    end

    trait :first_name_w do
      first_name 'Работ ник'
    end

    trait :wrong_first_name do
      first_name 'Работниf'
    end


    trait :middle_name do
      middle_name 'Работник'
    end

    trait :middle_name_w do
      middle_name 'Работ ник'
    end

    trait :wrong_middle_name do
      middle_name 'Работниf'
    end

    trait :last_name do
      last_name 'Работник'
    end

    trait :last_name_w do
      last_name 'Работ ник'
    end

    trait :wrong_last_name do
      last_name 'Работниf'
    end
  end
end
