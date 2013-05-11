# Read about factories at https://github.com/thoughtbot/factory_girl

FactoryGirl.define do
  factory :user do
    name 'Test User'
    email 'example@example.com'
    password '1q2w3e4r'
    password_confirmation '1q2w3e4r'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
	after(:create) {|user| user.add_role(:user_role)}

    factory :approved_user do
        after(:create) {|user| user.is_zombie = false}
    end
	
  end
  
  factory :admin, class: User do
    name 'Admin User'
    email 'admin@example.com'
    password '1q2w3e4r'
    password_confirmation '1q2w3e4r'
    # required if the Devise Confirmable module is used
    confirmed_at Time.now
	
	after(:create) {|user| user.add_role(:admin)}
	
  end
  
end