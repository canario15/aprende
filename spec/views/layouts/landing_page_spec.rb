require 'spec_helper'

describe "landing page" do
  before :each do
    visit '/'
  end

  it "apears Aprende jugando text" do
    expect(page).to have_content("Aprende jugando")
  end
end
