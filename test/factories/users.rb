FactoryGirl.define do
  factory :user do
    sequence(:name){|n| "name#{n}"}
    password 'hncsdn_pwd'
    password_confirmation 'hncsdn_pwd'
  end

  factory :admin, parent: :user do
    super_admin true
    allow_login true
  end
end
