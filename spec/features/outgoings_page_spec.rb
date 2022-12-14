require "rails_helper"

RSpec.describe "Outgoings Page" do
  let(:outgoings_header) { "What are your client's outgoings and deductions?" }
  let(:property_header) { "Does your client own the home they live in?" }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    create_proceeding_type: nil,
                    create_assessment_id: estimate_id)
  end

  before do
    allow(CfeConnection).to receive(:connection).and_return(mock_connection)
    visit_flow_page(passporting: false, target: :outgoings)
  end

  it "shows the correct page" do
    expect(page).to have_content outgoings_header
  end

  it "validates numbers in every value box" do
    click_on "Save and continue"
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Enter housing payments, if this does not apply enter 0")
      expect(page).to have_content("Enter childcare payments, if this does not apply enter 0")
      expect(page).to have_content("Enter maintenance payments to a former partner, if this does not apply enter 0")
      expect(page).to have_content("Enter payments towards legal aid in a criminal case, if this does not apply enter 0")
    end
  end

  it "validates that when values are entered, so are frequencies" do
    fill_in "outgoings-form-housing-payments-value-field", with: "100"
    click_on "Save and continue"
    expect(page).to have_css(".govuk-error-summary__list")
    within ".govuk-error-summary__list" do
      expect(page).to have_content("Select frequency of housing payments")
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
