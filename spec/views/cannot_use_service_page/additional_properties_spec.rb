require "rails_helper"

RSpec.describe "cannot_use_service/additional_properties.html.slim" do
  describe "additional_properties" do
    let(:assessment_code) { "123456" }
    let(:session_data) { { level_of_help:, partner:, assessment_code: assessment_code }.with_indifferent_access }
    let(:check) { Check.new(session_data) }

    before do
      assign(:check, check)
      render template: "cannot_use_service/additional_properties"
    end

    context "when viewing controlled work" do
      let(:level_of_help) { "controlled" }

      context "when client does not have a partner" do
        let(:partner) { false }

        it "displays the correct content" do
          expect(rendered).to include "You cannot use this service if your client owns a shared ownership property that they do not live in."
          expect(rendered).to match(/Use a (.+)controlled work form(.+) instead./)
        end
      end

      context "when has a partner" do
        let(:partner) { true }

        it "displays the correct content" do
          expect(rendered).to include "You cannot use this service if your client or their partner owns a shared ownership property that they do not live in."
          expect(rendered).to match(/Use a (.+)controlled work form(.+) instead./)
        end
      end
    end

    context "when viewing certificated work" do
      let(:level_of_help) { "certificated" }

      context "when client does not have a partner" do
        let(:partner) { false }

        it "displays the correct content" do
          expect(rendered).to include "You cannot use this service if your client owns a shared ownership property that they do not live in."
          expect(rendered).to include "To get a calculation, apply for legal aid using CCMS."
        end
      end

      context "when client has a partner" do
        let(:partner) { true }

        it "displays the correct content" do
          expect(rendered).to include "You cannot use this service if your client or their partner owns a shared ownership property that they do not live in."
          expect(rendered).to include "To get a calculation, apply for legal aid using CCMS."
        end
      end
    end
  end
end
