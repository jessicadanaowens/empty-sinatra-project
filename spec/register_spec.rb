require 'spec_helper'

feature "User can register and login" do
  scenario "with a valid username and password" do
    visit "/"

    click_on "Register Now"

    fill_in "Username", :with => "jetaggart"
    fill_in "Password", :with => "password"
    fill_in "Repeat Password", :with => "password"
    click_on "Register/Login"

    expect(page).to have_content("Welcome, jetaggart")

    #user can log out

    click_on "Logout"
    expect(page).to have_content("Thank you for visiting")

    #user cannot register with a name that already exists

    click_on "Register Now"

    fill_in "Username", :with => "jetaggart"
    fill_in "Password", :with => "password"
    fill_in "Repeat Password", :with => "password"
    click_on "Register/Login"

    expect(page).to have_content("Username is already taken")

    #user can login with a registered username and password

    visit "/"

    fill_in "Username", :with => "jetaggart"
    fill_in "Password", :with => "password"
    click_on "Login"

    expect(page).to have_content("Welcome, jetaggart")
    click_on "Logout"

    #user cannot login with an incorrect password

    visit "/"

    fill_in "Username", :with => "jetaggart"
    fill_in "Password", :with => "incorrect_password"
    click_on "Login"

    expect(page).to have_content("Password is incorrect")
  end

  scenario "user cannot login with an unregistered username and password" do

    visit "/"

    fill_in "Username", :with => "jess"
    fill_in "Password", :with => "password"
    click_on "Login"

    expect(page).to have_content("Username doesn't exist")
  end

  scenario "when user repeats the wrong password, an error message is displayed" do
    visit "/register"

    fill_in "Username", :with => "Jess"
    fill_in "Password", :with => "password"
    fill_in "Repeat Password", :with => "pass"
    click_on "Register/Login"

    expect(page).to have_content("Password must match other password")
  end


end

