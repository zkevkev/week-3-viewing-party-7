require 'rails_helper'

RSpec.describe 'Movies Index Page' do
  before do 
    @user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123', password_confirmation: 'password123')
    i = 1
    20.times do 
      Movie.create(title: "Movie #{i} Title", rating: rand(1..10), description: "This is a description about Movie #{i}")
      i+=1
    end 
  end 

  context 'when not logged in' do
    it 'does not allow visitor to create a viewing party' do
      movie_1 = Movie.first
      
      visit "users/#{@user1.id}/movies/#{movie_1.id}"

      click_button "Create a Viewing Party"

      expect(page).to have_content('You must be logged in or registered to create a movie party')
    end
  end

  context 'when logged in' do
    it 'shows all movies' do 
      user = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
      
      visit login_path
      
      fill_in :email, with: user.email
      fill_in :password, with: user.password
    
      click_on "Log In"

      visit "users/#{@user1.id}"

      click_button "Find Top Rated Movies"

      expect(current_path).to eq("/users/#{@user1.id}/movies")

      expect(page).to have_content("Top Rated Movies")
      
      movie_1 = Movie.first

      click_link(movie_1.title)

      expect(current_path).to eq("/users/#{@user1.id}/movies/#{movie_1.id}")

      expect(page).to have_content(movie_1.title)
      expect(page).to have_content(movie_1.description)
      expect(page).to have_content(movie_1.rating)
    end 
  end
end