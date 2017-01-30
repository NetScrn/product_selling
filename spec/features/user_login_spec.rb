require 'rails_helper'

RSpec.feature "Registred Users can login" do
  let(:user) { create(:user) }

  it 'successful' do
    visit root_path

    click_link "Log in"

    fill_in :user_email, with: user.email
    fill_in :user_password, with: 'password'

    click_button 'Log in'

    expect(page).to have_content user.email
  end
end