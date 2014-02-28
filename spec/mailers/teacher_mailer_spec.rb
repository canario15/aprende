require "spec_helper"

describe TeacherMailer do
  describe "trivia_statistics" do
    let(:mail) { TeacherMailer.trivia_statistics }

    it "renders the headers" do
      expect(mail.subject).to eq("Trivia statistics")
      expect(mail.to).to eq(["to@example.org"])
      expect(mail.from).to eq(["from@example.com"])
    end

    it "renders the body" do
      expect(mail.body.encoded).to match("Hi")
    end
  end

end
