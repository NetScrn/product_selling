require 'rails_helper'

RSpec.feature "User can create sale of product" do
  let(:user) { create(:user) }

  scenario "Valid sale" do
    create(:product, name: 'Amazing Product')
    login_as user
    visit new_sale_path

    select 'Amazing Product', from: 'Product'
    fill_in 'Cost',           with: '10.10'
    select '2015',            from: 'sale_date_of_purchase_1i'
    select 'December',        from: 'sale_date_of_purchase_2i'
    select '10',              from: 'sale_date_of_purchase_3i'

    click_button 'Create Sale'

    expect(page).to have_content 'Sale has been created'
    expect(page).to have_content 'Amazing Product'
    expect(page).to have_content '2015-12-10'
  end

  scenario "Invalid sale" do
    create(:product, name: 'Amazing Product')
    login_as user
    visit new_sale_path

    select 'Amazing Product', from: 'Product'
    fill_in 'Cost',           with: '0  '
    select '2015',            from: 'sale_date_of_purchase_1i'
    select 'December',        from: 'sale_date_of_purchase_2i'
    select '10',              from: 'sale_date_of_purchase_3i'

    click_button 'Create Sale'

    expect(page).to have_content 'Sale has not been created'
    expect(page).to have_content 'must be greater than 0'
  end
end