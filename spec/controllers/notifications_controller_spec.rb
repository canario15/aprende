require 'spec_helper'

describe NotificationsController do

  before :each do
    @notification = Notification.make!
    @admin = Admin.make!
    sign_in @admin
  end

  describe "GET 'index' logged in as Admin" do
    it "returns http success" do
      get 'index'
      expect(response).to be_success
    end

    it 'render the index template' do
      get 'index'
      expect(response).to render_template(:index)
    end
  end

  describe "POST 'create'" do
    it "creates a new Notification" do
      get 'new'
      expect(response.code).to eq("200")
    end

    it "returns http success" do
      params = {:notification => {:title => "Juga a la trivia 1", :description => "Jugar a la trivia 1"}}
      expect {post('create', params) }.to change{Notification.count}.by(1)
    end
  end

  describe "#logic_delete" do
    it "inactivates notification" do
      @notification = Notification.make!
      xhr :post, :logic_delete, {notification_id: @notification.id}
      n = Notification.find @notification.id
      expect(n.active).to be(false)
    end
  end
end
