FactoryGirl.define do
  factory :user do
    username              "name1"
    email                 "name1@mail.com"
    password              "foobar"
    password_confirmation "foobar"
    
    factory :admin do
      admin true
    end
  end
  
  factory :article do
    name        "Name 1"
    description "Description 1"
    content     "Content 1"
    user
  end
  
  factory :comment do
    comment "Comment 1"
    user
    article
  end
  
end