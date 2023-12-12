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

  context 'when not logged in' do
    it 'has links/buttons that link to correct pages' do 
      click_button "Create New User"
      
      expect(current_path).to eq(register_path) 
      
      visit '/'
      click_link "Home"

      expect(current_path).to eq(root_path)

      visit '/'
      click_button "Login"

      expect(current_path).to eq(login_path)
    end 

    it 'does not allow visitor to navigate to /dashboard' do                     
      visit '/dashboard'
save_and_open_page
      expect(page).to have_content('You must be logged in or registered to access your dashboard')
    end
  end
  
  context 'when logged in' do
    it "lists out existing users' emails" do 
      user1 = User.create(name: "User One", email: "user1@test.com", password: 'password123', password_confirmation: 'password123')
      user2 = User.create(name: "User Two", email: "user2@test.com", password: 'password123', password_confirmation: 'password123')
      user3 = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
      
      visit login_path
      
      fill_in :email, with: user3.email
      fill_in :password, with: user3.password
    
      click_on "Log In"

      expect(page).to have_content('Existing Users:')
  
      within('.existing-users') do 
        expect(page).to have_content(user1.email)
        expect(page).to have_content(user2.email)
      end     
    end 

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

    # it '' do
    #   user = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
  
    #   visit login_path
    
    #   fill_in :email, with: user.email
    #   fill_in :password, with: user.password
    
    #   click_on "Log In"
    # end
  end
end
