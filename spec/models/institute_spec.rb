require 'spec_helper'

describe Institute do
  describe "attributes" do
    it { should respond_to(:name) }
    it { should respond_to(:contact) }
    it { should respond_to(:phone) }
    it { should respond_to(:email) }
  end

  describe "relationships" do
     it { should respond_to(:state) }
     it { should respond_to(:city) }
  end

  describe "validate the presence of attributes in Institutes:" do
    it "must have a name" do
      expect(subject).to validate_presence_of :name
    end
  end

  describe 'Institute Create' do
    it 'Creates an Institute' do
      expect{ Institute.make! }.to (change(Institute, :count).by(1))
    end

    it 'with name nil' do
      expect{Institute.make!(name: nil)}.to raise_error
    end
  end

  describe 'Institute Update' do
    before :each do
      @institute = Institute.make!
    end

    it 'Updates an Institute' do
      params = {:name =>"liceo 3"}
      @institute.update!(params)
      expect(@institute.name).to eq('liceo 3')
    end

    it 'Updates an Institute, without name' do
      params = {:name => nil}
      expect{@institute.update!(params)}.to raise_error
    end

  end
end
