require "spec_helper"

describe InvitationMailer do
  describe "beta_invitation" do
    let(:mail) { InvitationMailer.beta_invitation }

    it "renders the headers" do
      mail.subject.should eq("Beta invitation")
      mail.to.should eq(["to@example.org"])
      mail.from.should eq(["from@example.com"])
    end

    it "renders the body" do
      mail.body.encoded.should match("Hi")
    end
  end

end
