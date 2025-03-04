require "rails_helper"

RSpec.describe "property", :calls_cfe_early_returns_not_ineligible, type: :feature do
  let(:partner) { false }

  before do
    start_assessment
    fill_in_forms_until(:applicant)
    if partner
      fill_in_applicant_screen(partner: "Yes")
    else
      fill_in_applicant_screen(partner: "No")
    end
    fill_in_forms_until(:property)
  end

  it "performs validations" do
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
  end

  it "stores my responses in the session" do
    choose "Yes, owned outright"
    click_on "Save and continue"

    expect(session_contents["property_owned"]).to eq "outright"
  end

  it "shows the shared ownership option", :shared_ownership do
    expect(page).to have_field("Yes, through a shared ownership scheme", type: "radio")
  end

  it "stores my shared ownership response in the session", :shared_ownership do
    choose "Yes, through a shared ownership scheme"
    click_on "Save and continue"

    expect(session_contents["property_owned"]).to eq "shared_ownership"
  end

  context "when MTR accelerated is in effect" do
    context "when single" do
      it "shows new content" do
        expect(page).to have_content("who are away from their usual home")
      end
    end

    context "with partner" do
      let(:partner) { true }

      it "shows new content" do
        expect(page).to have_content("Clients who are away from their usual home")
      end

      context "with check answers" do
        before do
          fill_in_forms_until(:check_answers)
        end

        it "shows new content" do
          expect(page).to have_content "Home client usually lives in"
        end
      end
    end
  end
end
