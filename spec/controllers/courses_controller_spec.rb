require 'spec_helper'

describe CoursesController do
  before :all do
    @level = Level.make!
  end

  describe "GET 'index'" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do

    it "create a new course" do
      get 'create', {:course => {:title => "new course", :level_id => @level.id}}
      change{Course.count}.by(1)
    end

    it "returns http success" do
      post 'create', {:course => {:title => "new course", :level_id => @level.id}}
      expect(response) == 1
    end
  end

  describe "GET 'edit'" do
    before :each do
      @course = Course.make!
    end

    it "returns http success" do
      get 'edit', {:id => @course.id}
      expect(response).to be_success
    end
  end

  describe "POST 'update'" do
    before :each do
      @course = Course.make!
    end

    it "returns http success" do
      post 'update', {:id=> @course.id, :course => {:title => "Update course", :level_id => @level.id}}
      expect(response) == 1
    end
  end

end
