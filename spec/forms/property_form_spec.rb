require "rails_helper"

RSpec.describe "property", :might_call_cfe, type: :feature do
  let(:partner) { false }
  let(:content_date) { Time.zone.today }

  before do
    travel_to content_date
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

  context "when MTR accelerated is in effect" do
    let(:before_date) { Date.new(2023, 2, 15) }
    let(:after_date) { Date.new(2024, 7, 15) }

    context "when single" do
      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("If your client is temporarily away from where they normally live")
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

        it "shows new content" do
          expect(page).to have_content("who are away from their usual home")
        end
      end
    end

    context "with partner" do
      let(:partner) { true }

      context "without MTR accelerated" do
        let(:content_date) { before_date }

        it "shows old content" do
          expect(page).to have_content("Clients in prison")
        end

        context "with check answers" do
          before do
            fill_in_forms_until(:check_answers)
          end

          it "shows old content" do
            expect(page).to have_content "Home client lives in"
          end
        end
      end

      context "with MTR accelerated", :mtr_accelerated_flag do
        let(:content_date) { after_date }

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
end
