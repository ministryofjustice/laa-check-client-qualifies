require "rails_helper"

RSpec.describe "Provider User Page" do
  let(:client_details_header) { "Your client's details" }
  let(:referral_header) { "You cannot use this service to get a financial eligibility estimate for legal aid" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  describe "radio buttons" do
    before do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)
      visit "/provider_users"
    end

    it "errors when nothing is entered" do
      click_on "Save and continue"
      expect(page).to have_css(".govuk-error-summary__list")
      within ".govuk-error-summary__list" do
        expect(page).to have_content(I18n.t("activemodel.errors.models.provider_user.attributes.blank"))
      end
    end

    context "when the user is a legal aid provider" do
      it "redirects to the build estimates page" do
        select_boolean_value("provider-user", :provider_user_valid, true)
        click_on "Save and continue"
        expect(page).to have_content client_details_header
      end
    end

    context "when the user is not a valid user" do
      it "redirects to the referrals page" do
        select_boolean_value("provider-user", :provider_user_valid, false)
        click_on "Save and continue"
        expect(page).to have_content referral_header
      end
    end
  end
end
