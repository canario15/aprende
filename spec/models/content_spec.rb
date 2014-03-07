require 'spec_helper'

describe Content do

  describe "relations" do
    it { should respond_to(:containable) }
    it { should accept_nested_attributes_for :containable }
  end

  describe "validate attributes" do
    it { should validate_presence_of(:containable) }
  end

  describe 'Create' do
    it 'with containable Pdf' do
      expect{ Content.make!(containable: Pdf.make!) }.to change { Content.count }.by(1)
    end

    it 'create Pdf' do
      expect{ Content.make!(containable: Pdf.make!) }.to change { Pdf.count }.by(1)
    end

    it 'with containable Written' do
      expect{ Content.make!(containable: Written.make!) }.to change { Content.count }.by(1)
    end

    it 'create Written' do
      expect{ Content.make!(containable: Written.make!) }.to change { Written.count }.by(1)
    end

    it 'without containable' do
      expect{ Content.make! }.to raise_error
    end
  end

  describe 'Destroy' do
    context 'Pdf' do
      before :each do
        @content = Content.make!(containable: Pdf.make!)
      end
      it 'with containable' do
        expect{ @content.destroy }.to change { Content.count }.by(-1)
      end

      it 'Pdf' do
        expect{ @content.destroy }.to change { Pdf.count }.by(-1)
      end
    end

    context 'Written' do
      before :each do
        @content = Content.make!(containable: Written.make!)
      end
      it 'with containable' do
        expect{ @content.destroy }.to change { Content.count }.by(-1)
      end

      it 'Written' do
        expect{ @content.destroy }.to change { Written.count }.by(-1)
      end
    end
  end
end
