require 'spec_helper'

describe "home/index.html.erb" do
  before :each do
    City.make!
    @user = User.make!
    visit new_user_session_path
    fill_in "user_email", with: @user.email
    fill_in "user_password", with: "1234567890"
    click_on "Entra!"
  end
  it "renders Bienvenido a Aprende text" do
    visit home_path
    expect(page).to have_content("Bienvenido")
  end
end
