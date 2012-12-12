# -*- encoding : utf-8 -*-
# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :code_value do
    code 1
    code_desc "MyString"
    fine 1
    point 1
  end
end
