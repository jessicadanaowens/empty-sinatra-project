require 'spec_helper'

feature "Picture uploading" do
  scenario "user can upload a picture" do
    visit "/"

    click_on "Register Now"

    fill_in "Username", :with => "jetaggart"
    fill_in "Password", :with => "password"
    fill_in "Repeat Password", :with => "password"
    click_on "Register/Login"

    attach_file('Image', 'spec/frame.png')
    click_button "upload"

    within('#container') do
      image = page.find('img')
      expect(image).to_not be_nil
      expect(image['src']).to eq 'https://s3.amazonaws.com/frame_it_bucket/frame.png'
    end

    #user can select an image and go to a new page

    click_button "Select"

    within('#container') do
      image = page.find('img')
      expect(image).to_not be_nil
      expect(image['src']).to eq 'https://s3.amazonaws.com/frame_it_bucket/frame.png'
    end

    click_link "Back to gallery"

    #user can delete images

    click_button "Delete"
    img = page.find('img')
    expect(img['src']).to_not eq 'https://s3.amazonaws.com/frame_it_bucket/frame.png'

    #user gets error message if they don't select a file before clicking upload

    click_button "upload"
    expect(page).to have_content("Please select an image to upload")

  end
end

