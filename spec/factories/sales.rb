FactoryGirl.define do
  factory :sale do
    cost 10.00
    date_of_purchase Time.now
  end
end