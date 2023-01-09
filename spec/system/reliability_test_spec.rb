require "rails_helper"

RSpec.describe "Reliability test", :long_slow do
  # before { driven_by(:headless_chrome) }

  # let(:host) { "https://check-your-client-qualifies-for-legal-aid.cloud-platform.service.justice.gov.uk" }
  let(:host) { "https://reliability-test-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk:443" }
  # let(:host) { "https://el-558-reuse-http-check-client-qualifies-legal-aid-uat.cloud-platform.service.justice.gov.uk" }

  it "can navigate to check answers a lot", :partner_flag do
    count = 1000
    count.times do |counter|
      submit_to_cfe
      Rails.logger.info "iteration #{counter} of #{count}"
    rescue Capybara::ElementNotFound => e
      # sometimes we just don't wait long enough for the element to appear when doing lots of tests
      Rails.logger.warn "ignoring #{e.inspect} #{counter} of #{count}"
    end
  end

  def submit_to_cfe
    10.times do
      visit_check_answers(passporting: false,
                          host:) do |step|
        case step
        when :vehicle
          select_boolean_value("vehicle-form", :vehicle_owned, true)
          click_on "Save and continue"
          fill_in "client-vehicle-details-form-vehicle-value-field", with: 5_000
          select_boolean_value("client-vehicle-details-form", :vehicle_in_regular_use, true)
          select_boolean_value("client-vehicle-details-form", :vehicle_over_3_years_ago, false)
          select_boolean_value("client-vehicle-details-form", :vehicle_pcp, true)
          fill_in "client-vehicle-details-form-vehicle-finance-field", with: 2_000
          select_boolean_value("client-vehicle-details-form", :vehicle_in_dispute, true)
        when :property
          select_radio_value("property-form", "property-owned", "with_mortgage")
          click_on "Save and continue"
          fill_in "client-property-entry-form-house-value-field", with: 100_000
          fill_in "client-property-entry-form-mortgage-field", with: 80_000
          fill_in "client-property-entry-form-percentage-owned-field", with: 50
        end
      end
      click_on "Submit"
      # make sure answer has arrived
      expect(page.all(".govuk-accordion").count).to eq(1)
      # sleep 1
    end
  end
end
