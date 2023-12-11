require 'rails_helper'

RSpec.describe 'Logging In' do
  it 'can log in with valid credentials' do
    user = User.create(name: 'funbucket13', email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')

    visit root_path

    click_on 'Login'

    expect(current_path).to eq(login_path)

    fill_in :name, with: user.name
    fill_in :password, with: user.password

    click_on 'Log In'

    expect(current_path).to eq(root_path)

    expect(page).to have_content("Welcome, #{user.name}")
  end

  it "cannot log in with bad credentials" do
    user = User.create(name: "funbucket13", email: 'user1@example.com', password: 'password123', password_confirmation: 'password123')
  
    visit login_path
  
    fill_in :name, with: user.name
    fill_in :password, with: "incorrect password"
  
    click_on "Log In"
  
    expect(current_path).to eq(login_path)
  
    expect(page).to have_content("Sorry, your credentials are bad.")
  end
end
