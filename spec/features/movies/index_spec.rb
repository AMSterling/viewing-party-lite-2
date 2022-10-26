require 'rails_helper'

RSpec.describe 'Movie Index Page' do
  let!(:users) { create_list(:user, 3) }
  let!(:user1) { users.first }

  before :each do
    allow_any_instance_of(ApplicationController).to receive(:current_user).and_return(user1)
  end

  describe 'movie index tests', :vcr do
    it 'is linked from user discover page' do
      visit discover_path

      click_on 'Find Top Rated Movies'

      expect(current_path).to eq(movies_path)

      visit discover_path
      fill_in :q, with: 'wayne'
      click_on 'Find Movies'

      expect(current_path).to eq(movies_path)
    end

    it 'displays top forty movies'do
      VCR.use_cassette('displays_top_forty_movies') do
        visit discover_path

        click_on 'Find Top Rated Movies'

        expect(page).to have_link('The Godfather')
      end
    end

    it 'displays the searched movies' do
      VCR.use_cassette('returns_movies_from_search') do
        visit discover_path
        fill_in :q, with: 'wayne'
        click_on 'Find Movies'

        expect(page).to have_content('Wayne')
      end
    end

    it 'has button to return to discover page' do
      visit discover_path

      click_on 'Find Top Rated Movies'

      expect(page).to have_button('Discover Page')

      click_on 'Discover Page'

      expect(current_path).to eq(discover_path)
    end

    it 'has a links to movie details' do
      visit discover_path

      click_on 'Find Top Rated Movies'
      click_on 'The Godfather'

      expect(current_path).to eq(movie_path(238))
      expect(page).to have_content('The Godfather')
      expect(page).to have_button('Discover Page')
    end
  end
end
