require "rails_helper"

RSpec.describe "Outgoings Page" do
  let(:outgoings_header) { "What are your client's outgoings and deductions?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: estimate_id) }

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    allow(mock_connection).to receive(:create_proceeding_type)
    visit estimate_build_estimate_path(estimate_id, :outgoings)
  end

  it "shows the correct page" do
    expect(page).to have_content outgoings_header
  end

  it "validates numbers in every value box" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please enter a 0 if your client makes no housing payments")
      expect(page).to have_content("Please enter a 0 if your client makes no maintenance payments")
      expect(page).to have_content("Please enter a 0 if your client makes no childcare payments")
      expect(page).to have_content("Please enter a 0 if your client makes no legal aid payments")
    end
  end

  it "validates that when values are entered, so are frequencies" do
    fill_in "outgoings-form-housing-payments-value-field", with: "100"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Please enter the frequency of your client's housing payments")
    end
  end

  it "moves onto property on successful submission with no income" do
    fill_in "outgoings-form-housing-payments-value-field", with: "100"
    fill_in "outgoings-form-childcare-payments-value-field", with: "200"
    fill_in "outgoings-form-legal-aid-payments-value-field", with: "300"
    fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
    find(:css, "#outgoings-form-housing-payments-frequency-every-week-field").click
    find(:css, "#outgoings-form-childcare-payments-frequency-every-two-weeks-field").click
    find(:css, "#outgoings-form-legal-aid-payments-frequency-monthly-field").click
    click_on "Save and continue"
    expect(page).to have_content(property_header)
  end
end
