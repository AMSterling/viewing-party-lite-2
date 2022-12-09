require 'rails_helper'

RSpec.describe 'user login' do
  let!(:users) { create_list(:user, 3) }
  let!(:user1) { users.first }
  let!(:user2) { users.second }
  let!(:user3) { users.third }

  before :each do
    visit root_path
  end

  it 'logs a user in and log out' do

    expect(page).to have_field(:email)
    expect(page).to have_field(:password)
    expect(page).to have_button('Log In')

    fill_in :email, with: "#{user1.email}"
    fill_in :password, with: "#{user1.password}"
    click_button 'Log In'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Welcome #{user1.name}")
    expect(page).to_not have_button('Log In')
    expect(page).to_not have_button('Create New User')
    expect(page).to have_link('Log Out')

    click_link 'Home'

    expect(current_path).to eq(root_path)

    within "#user-#{user1.id}" do
      expect(page).to have_link("#{user1.email}'s Dashboard")
    end
    within "#user-#{user2.id}" do
      expect(page).to_not have_link("#{user2.email}'s Dashboard")
      expect(page).to have_content("#{user2.email}")
    end
    within "#user-#{user3.id}" do
      expect(page).to_not have_link("#{user3.email}'s Dashboard")
      expect(page).to have_content("#{user3.email}")
    end

    click_link 'Log Out'

    expect(current_path).to eq(root_path)
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')
    expect(page).to_not have_link('Log Out')
    expect(page).to have_content('Existing Users')

    within "#user-#{user1.id}" do
      expect(page).to_not have_link("#{user1.email}'s Dashboard")
      expect(page).to have_content("#{user1.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, '**')}")
    end

    within "#user-#{user2.id}" do
      expect(page).to_not have_link("#{user2.email}'s Dashboard")
      expect(page).to have_content("#{user2.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, '**')}")
    end

    within "#user-#{user3.id}" do
      expect(page).to_not have_link("#{user3.email}'s Dashboard")
      expect(page).to have_content("#{user3.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, '**')}")
    end
  end

  it 'does not log a user in with invalid credentials' do

    fill_in :email, with: "#{user1.email}"
    fill_in :password, with: 'wrong'
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Invalid Credentials')
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')

    fill_in :email, with: "#{user1.name}"
    fill_in :password, with: "#{user1.password}"
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Invalid Credentials')
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')
  end

  it 'does not log a user in if any field is left blank' do

    fill_in :email, with: "#{user1.email}"
    fill_in :password, with: ''
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Invalid Credentials')
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')

    fill_in :email, with: ''
    fill_in :password, with: "#{user1.password}"
    click_button 'Log In'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('Invalid Credentials')
    expect(page).to have_button('Log In')
    expect(page).to have_button('Create New User')
  end

  it 'cannot visit pages that require a registered user' do
    visit dashboard_path

    expect(current_path).to eq(root_path)
    expect(page).to have_content('You must be logged in')

    visit discover_path

    expect(page).to have_button('Find Movies')

    fill_in :q, with: 'The Shawshank Redemption'

    click_on 'Find Movies'

    expect(current_path).to eq(movies_path)

    click_link 'The Shawshank Redemption'

    expect(page).to have_content('The Shawshank Redemption')
    expect(page).to have_content('Vote Average:')
    expect(page).to have_content('Runtime:')

    click_on 'Create Viewing Party for The Shawshank Redemption'

    expect(current_path).to eq(root_path)
    expect(page).to have_content('You must be logged in')
  end
end
