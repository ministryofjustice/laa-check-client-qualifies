require "rails_helper"

RSpec.describe "Partner with passporting", :vcr, :partner_flag do
  let(:arbitrary_fixed_time) { Time.zone.local(2022, 9, 5, 9, 0, 0) }

  before do
    travel_to arbitrary_fixed_time
  end

  describe "CFE submission" do
    before do
      driven_by(:headless_chrome)
      visit_check_answers(passporting: true, partner: true) do |page|
        case page
        when :partner_details
          select_boolean_value("partner-details-form", :over_60, true)
        end
      end
    end

    it "handles can submit to CFE" do
      click_on "Submit"

      expect(page).to have_content "Your client is likely to qualify for civil legal aid"
    end
  end
end
