require 'spec_helper'

describe TeachersController do

  describe "GET 'index'" do
    before :each do
      @teacher = Teacher.make!
      sign_in @teacher
    end

    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end
end
