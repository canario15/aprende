require 'spec_helper'

describe InstitutesController do

  describe "GET 'index'" do
    before :each do
      @admin = Admin.make!
      sign_in @admin
    end
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end
  end

  describe "POST 'create'" do
    before :each do
      @admin = Admin.make!
      sign_in @admin
      @city = City.make!
      @company = Company.make!
    end

    it "creates a new Institute and redirects to the Institutes index" do
      params = {:institute => { :company_id =>  @company.id, :name => "Liceo N° 2", :contact => "Juan Rodriguez", :email => "juanrod@hotmail.com", :phone => "2021025221",:city_id => @city.id}}
      expect{post('create', params)}.to change{Institute.count}.by(1)
      expect(response).to redirect_to institutes_path
    end
  end

   describe "POST 'update'" do
    before :each do
      @admin = Admin.make!
      sign_in @admin
      @institute = Institute.make!(company: @admin.company)
      @city = City.make!
    end

    it "returns http success institutes_path" do
      params = {:id=> @institute.id, :institute => {:company_id =>  @admin.company.id, :name => "Liceo N° 4", :contact => "Juan Rodriguez", :email => "juanrod@hotmail.com", :phone => "2021025221", :city_id => @city.id}}
      post('update', params)
      expect(response).to redirect_to(institutes_path)
    end
  end

  describe "GET 'edit'" do
    before :each do
      @admin = Admin.make!
      sign_in @admin
      @institute = Institute.make!(company: @admin.company)
    end

    it "returns http success" do
      get 'edit', {:id => @institute.id}
      expect(response).to be_success
    end
  end

end
