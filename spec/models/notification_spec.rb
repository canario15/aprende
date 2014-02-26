require 'spec_helper'

describe Notification do
  describe "attributes" do
    it { should respond_to(:title) }
    it { should respond_to(:description) }
  end

  describe "create Notification" do
    it 'new Notification in DB' do
      expect{Notification.make!}.to change{Notification.count}.by(1)
    end

    it 'new Notification in DB is active' do
      notification = Notification.make!
      expect(notification.active).to eq(true)
    end
  end

  describe '#inactivate' do
    before :each do
      @notification = Notification.make!
    end

    it 'turns into an inactive state an active Notification' do
      @notification.inactivate
      expect(@notification.active).to eq(false)
    end
  end
end
