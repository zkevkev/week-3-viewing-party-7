require 'rails_helper'

RSpec.describe 'Landing Page' do
  before :each do 
    user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123', password_confirmation: 'password123')
    user2 = User.create(name: "User Two", email: "user2@test.com", password: 'password123', password_confirmation: 'password123')
    visit '/'
  end 

  it 'has a header' do
    expect(page).to have_content('Viewing Party Lite')
  end

  it 'has links/buttons that link to correct pages' do 
    click_button "Create New User"
    
    expect(current_path).to eq(register_path) 
    
    visit '/'
    click_link "Home"

    expect(current_path).to eq(root_path)
  end 

  it 'lists out existing users' do 
    user1 = User.create(name: "User One", email: "user1@test.com")
    user2 = User.create(name: "User Two", email: "user2@test.com")

    expect(page).to have_content('Existing Users:')

    within('.existing-users') do 
      expect(page).to have_content(user1.email)
      expect(page).to have_content(user2.email)
    end     
  end 

  context 'when logged in' do
    it 'has a link to log out instead of login and create buttons' do
      user = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
  
      visit login_path
    
      fill_in :email, with: user.email
      fill_in :password, with: user.password
    
      click_on "Log In"

      expect(current_path).to eq(root_path)
      expect(page).to have_button("Log Out")
      expect(page).to_not have_button("Create New User")
      expect(page).to_not have_button("Login")
    end

    it 'log out link logs user out, redirects back, and buttons revert' do
      user = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
  
      visit login_path
    
      fill_in :email, with: user.email
      fill_in :password, with: user.password
    
      click_on "Log In"

      expect(current_path).to eq(root_path)

      click_on "Log Out"

      expect(page).to_not have_link("Log Out")
      expect(page).to have_button("Create New User")
      expect(page).to have_button("Login")
    end
  end
end
