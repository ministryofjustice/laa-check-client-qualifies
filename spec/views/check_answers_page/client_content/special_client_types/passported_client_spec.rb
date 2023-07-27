require "rails_helper"

RSpec.describe "estimates/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    params[:id] = :id
    allow(view).to receive(:form_with)
    render template: "estimates/check_answers"
  end

  describe "passported client" do
    let(:session_data) { build(:minimal_complete_session, passporting: true) }

    let(:text) { page_text }

    context "without a partner" do
      it "renders client details and capital sections" do
        expect(text).to include("Client details")
        expect(text).to include("Client assets")
      end

      it "does not render income and outgoings sections" do
        expect(text).not_to include("Client outgoings and deductions")
        expect(text).not_to include("Client employment income")
      end

      it "renders relevant content" do
        expect(text).to include("Does your client receive a passporting benefit?Yes")
      end
    end

    context "with a partner" do
      let(:session_data) { build(:minimal_complete_session, partner: true, passporting: true) }

      it "renders partner details and capital sections" do
        expect(text).to include("Partner assets")
        expect(text).to include("Partner details")
      end

      it "does not render partner income and outgoings sections" do
        expect(text).not_to include("Partner outgoings and deductions")
        expect(text).not_to include("Partner employment income")
      end

      it "renders the content" do
        expect(text).to include("Does your client receive a passporting benefit?Yes")
        expect(text).to include("Does your client have a partner?Yes")
      end
    end
  end
end
