require 'rails_helper'

RSpec.describe 'user login' do
  let!(:users) { create_list(:user, 3) }
  let!(:user1) { users.first }
  let!(:user2) { users.second }
  let!(:user3) { users.third }

  it 'logs a user in' do
    visit root_path

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)
    expect(page).to have_button('Log In')

    fill_in :email, with: "#{user1.email}"
    fill_in :password, with: "#{user1.password}"
    click_button 'Log In'

    expect(current_path).to eq(user_dashboard_path(user1))
    expect(page).to have_content("Welcome #{user1.name}")
    expect(page).to_not have_button('Log In')
    expect(page).to_not have_button('Create New User')
  end

  it 'does not log a user in with invalid credentials' do
    visit root_path

    fill_in :email, with: "#{user1.email}"
    fill_in :password, with: 'wrong'
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Invalid Credentials')
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')
  end
end
