require 'spec_helper'

describe CoursesController do
  before :all do
    @level = Level.make!
  end

  describe "GET 'index'" do
    it "returns http success(code=200)" do
      get 'index'
      expect(response.code).to eq("200")
    end
  end

  describe "GET 'new'" do
    it "returns http success" do
      get 'new'
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'create'" do
    before :each do
      @params = {:course => {:title => "new course", :level_id => @level.id}}
    end

    it "create a new course" do
      expect {post('create', @params)}.to change{Course.count}.by(1)
    end

    it "create course and returns http courses_url" do
      post 'create', @params
      expect(response).to redirect_to(courses_url)
    end
  end

  describe "GET 'edit'" do
    before :each do
      @course = Course.make!
    end

    it "returns http success(code=200)" do
      get 'edit', {:id => @course.id}
      expect(response.code).to eq("200")
    end
  end

  describe "POST 'update'" do
    before :each do
      @course = Course.make!
    end

    it "returns http success and redirect_to courses_url" do
      params = {:id=> @course.id, :course => {:title => "Update course", :level_id => @level.id}}
      post 'update', params
      expect(response).to redirect_to(courses_url)
    end
  end

end
