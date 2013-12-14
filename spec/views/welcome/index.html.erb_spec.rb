require 'spec_helper'

describe "welcome/index.html.erb" do
  before :each do
    visit "/"
  end
  it "renders Aprende jugando text" do
    expect(page).to have_content("Aprende jugando")
  end
end
