require 'rails_helper'

RSpec.feature 'Correct reports' do
  let(:user) { create(:user) }
  let(:product1) { create(:product, name: 'Phone') }
  let(:product2) { create(:product, name: 'Laptop') }

  before(:each) do
    login_as user
    create(:sale, cost: 25.00, date_of_purchase: '2016-01-01', product: product1)
    create(:sale, cost: 50.00, date_of_purchase: '2016-02-01', product: product1)
    create(:sale, cost: 120.00, date_of_purchase: '2016-01-01', product: product2)
    create(:sale, cost: 150.00, date_of_purchase: '2016-02-01', product: product2)
  end

  context 'sales per product' do
    scenario "plain" do
      visit sales_per_product_path
      expect(page).to have_css("table tr", text: /Phone.+75/)
      expect(page).to have_css("table tr", text: /Laptop.+270/)
    end

    scenario "with filtration" do
      visit sales_per_product_path

      fill_in "product_name", with: 'Phone'
      fill_in "From", with: '2016-01-15'
      fill_in "To", with: '2016-02-15'
      click_button 'Find'

      expect(page).to have_css("table tr", text: /Phone.+50/)
      expect(page).to_not have_css("table tr", text: /Laptop/)
    end
  end

  context 'sales per month' do
    scenario 'plain' do
      visit sales_per_month_path
      expect(page).to have_css("table tr", text: /January 2016.+145/)
      expect(page).to have_css("table tr", text: /February 2016.+200/)
    end

    scenario "with filtration" do
      visit sales_per_month_path

      select "Phone", from: 'product_name'
      fill_in "From", with: '2016-01-01'
      fill_in "To", with: '2016-01-31'
      click_button 'Find'

      expect(page).to have_css("table tr", text: /January 2016.+25/)
      expect(page).to_not have_css("table tr", text: /February/)
    end
  end

end