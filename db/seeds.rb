User.destroy_all
Product.destroy_all
Sale.destroy_all

User.create!(email: 'user@example.com', password: 'password')
(1..100).map do |n|
  Product.create! name: "Product #{n}"
end.each do |p|
  5.times do
    Sale.create! product_id: p.id,
                 cost: rand(50.00..100.00).round(2),
                 date_of_purchase: "2016-#{rand(1..12)}-01"
  end
end
