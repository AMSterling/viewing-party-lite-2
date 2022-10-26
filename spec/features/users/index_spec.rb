require 'rails_helper'

RSpec.describe 'Landing Page' do
  describe 'When a user visits the root path' do
    let!(:users) { create_list(:user, 3) }
    let!(:user1) { users.first }
    let!(:user2) { users.second }
    let!(:user3) { users.third }

    before :each do
      visit root_path
    end

    it 'should be on the landing page with title' do

      expect(page).to have_content('Viewing Party')
    end

    it 'should have button to create a new user' do

      expect(page).to have_button('Create New User')

      click_button 'Create New User'

      expect(current_path).to eq(register_path)
    end

    it 'has section for existing users' do
      expect(page).to have_content('Existing Users')

      within('#existing_users') do
        within("#user-#{user1.id}") do
          expect(page).to have_content("#{user1.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, "**")}")
        end

        within("#user-#{user2.id}") do
          expect(page).to have_content("#{user2.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, "**")}")
        end

        within("#user-#{user3.id}") do
          expect(page).to have_content("#{user3.email.gsub(/(?<=[\w\d])[\w\d]+(?=[\w\d])/, "**")}")
        end
      end
    end

    it 'has a home link at top of page' do
      expect(page).to have_link('Home')

      click_link 'Home'

      expect(current_path).to eq(root_path)
    end
  end
end
