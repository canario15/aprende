require 'spec_helper'

describe Written do

  describe "attributes" do
    it { should respond_to(:document) }
  end

  describe "relations" do
    it { should have_many(:contents) }
  end

  describe "validate attributes" do
    it { should validate_presence_of(:document) }
  end

  describe 'Create' do
    it 'with document ' do
      expect{ Written.make! }.to change { Written.count }.by(1)
    end

    it 'with document nil' do
      expect{ Written.make!(document: nil) }.to raise_error
    end
  end
end
