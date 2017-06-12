require 'rails_helper'

describe "Pages" do
  
  subject{page}
  
  describe "Articles page" do
    before {visit articles_path}
    it{should have_selector("h1", text: "Articles")}
  end
  
  describe "Users page" do
    before {visit users_path}
    it{should have_selector("h1", text: "Users")}
  end
  
  describe "Sign in" do
    before {visit new_user_session_path}
    it{should have_selector("h1", text: "Sign in")}
  end
  
  describe "Sign up" do
    before {visit new_user_registration_path}
    it{should have_selector("h1", text: "Sign up")}
  end
  
  describe "Sign out" do
  end
  
  describe "Test nav links" do
    it "Should have the right links" do
      visit root_path
      click_link "Articles"
      should have_content("Articles");
      click_link "Users"
      should have_content("Users")
      click_link "Sign in"
      should have_content("Sign in")
      click_link "Sign up"
      should have_content("Sign up")
    end
  end
end
