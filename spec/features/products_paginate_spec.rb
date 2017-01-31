require 'rails_helper'

RSpec.feature "Products paginate" do
  let(:user) { create(:user) }
  let!(:products) { create_list(:product, 16) }

  it "15 per page" do
    login_as user
    visit products_path

    expect(page).to have_content products[14].name
    expect(page).to_not have_content products[15].name

    click_link '2'

    expect(page).to_not have_content products[14].name
    expect(page).to have_content products[15].name
  end
end