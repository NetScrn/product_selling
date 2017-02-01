require 'rails_helper'

RSpec.feature "Users can create Products" do
  let(:user) { create(:user) }
  let(:created_car) { create(:product, name: 'created_car') }

  before(:each) do
    login_as user
    visit new_product_path
  end

  scenario "Valid product" do
    fill_in 'Name', with: 'Really Good Car'
    click_button "Create Product"

    expect(page).to have_content 'Product has been successfully created'
    expect(page).to have_content 'Really Good Car'
  end

  scenario "Invalid product" do
    fill_in 'Name', with: ''
    click_button "Create Product"

    within(".product_name") do
      expect(page).to have_content "can't be blank"
    end
    expect(page).to have_content 'Product has not been created'
  end

  scenario "Already created car" do
    created_car
    fill_in 'Name', with: 'created_car'
    click_button "Create Product"

    within(".product_name") do
      expect(page).to have_content "has already been taken"
    end
    expect(page).to have_content 'Product has not been created'
  end
end