require 'spec_helper'

describe Pdf do

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
      expect{ Pdf.make! }.to change { Pdf.count }.by(1)
    end

    it 'with invalid type' do
      document = File.new(File.join(Rails.root, 'spec', 'fixtures', 'Test.jpeg'))
      expect{ Pdf.make!(document: document) }.to raise_error
    end

    it 'with document nil' do
      expect{ Pdf.make!(document: nil) }.to raise_error
    end
  end
end
