# -*- coding: utf-8 -*-
# This file should contain all the record creation needed to seed the database with its default values.
# The data can then be loaded with the rake db:seed (or created alongside the db with db:setup).
#
# Examples:
#
#   cities = City.create([{ name: 'Chicago' }, { name: 'Copenhagen' }])
#   Mayor.create(name: 'Emanuel', city: cities.first)

%w(
 git rails ruby rspec html css
 sinatra postgres angularjs sql
 python sass less capistrano
).each do |skill|
  Skill.create!(name: skill)
end

10.times do |n|
  v = Vacancy.create!(
    name: "SuperJob# #{n}",
    email: "my_email_#{n}@gmail.com",
    phone: "+7(999)123-45-6#{n}",
    published_at: DateTime.now,
    validity: 15,
    salary: 10000 + (n * 5000)
  )
  v.skills << Skill.all.sample(3)
end

10.times do |n|
  v = Employee.create!(
    first_name: "Работник",
    last_name: "Работников",
    middle_name: "Работникович",
    email: "employee_email_#{n}@gmail.com",
    phone: "+7(999)123-45-6#{n}",
    salary: 10000 + (n * 5000),
    status: :search
  )
  v.skills << Skill.all.sample(3)
end
