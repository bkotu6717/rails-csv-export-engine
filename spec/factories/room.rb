require 'faker'

FactoryGirl.define do
  factory :room do
    name { Faker::Name.title }
    number { Faker::Number.number(5) }
    capacity { Faker::Number.number(4) }
  end
end