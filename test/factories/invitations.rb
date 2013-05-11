# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :invitation do
    fullname "MyString"
    email "MyString"
    institution "MyString"
  end
end
