require "rails_helper"

RSpec.describe "Provider User Page" do
  let(:first_page_header) { I18n.t("estimate_flow.applicant.heading") }
  let(:referral_header) { I18n.t("referrals.show.page_heading") }
  let(:estimate_id) { SecureRandom.uuid }

  describe "radio buttons" do
    before do
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
        expect(page).to have_content first_page_header
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
