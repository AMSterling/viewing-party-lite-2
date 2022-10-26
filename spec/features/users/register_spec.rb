require 'rails_helper'

RSpec.describe 'User registration page' do
  it 'link for path to register new user' do
    visit root_path

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content('Name: ')
    expect(page).to have_content('Email: ')
    expect(page).to have_content('Password: ')
    expect(page).to have_content('Password Confirmation:')
    expect(page).to have_button('Create New User')
  end

  it 'has form to enter name and email for new user and email is unique' do
    visit register_path

    fill_in :name, with: 'Jerry'
    fill_in :email, with: 'jerry@mail.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'

    click_button 'Create New User'

    expect(current_path).to eq(dashboard_path)
    expect(page).to have_content("Jerry's Dashboard")
    expect(page).to have_content('Welcome Jerry')

    visit register_path

    fill_in :name, with: 'Jer'
    fill_in :email, with: 'jerry@mail.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'password'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content('Email has already been taken')
  end

  it 'checks password and confirmation match' do
    visit register_path

    fill_in :name, with: 'Jerry'
    fill_in :email, with: 'jerry@mail.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'pa$$word'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Password confirmation doesn't match Password")
  end

  it 'checks name exists' do
    visit register_path

    fill_in :email, with: 'name@mail.com'
    fill_in :password, with: 'password'
    fill_in :password_confirmation, with: 'pa$$word'

    click_button 'Create New User'

    expect(current_path).to eq(register_path)
    expect(page).to have_content("Name can't be blank")
  end
end
