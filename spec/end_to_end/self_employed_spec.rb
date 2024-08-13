require "rails_helper"

RSpec.shared_context "with a check containing employment data" do
  before do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen(frequency: "Every week",
                          gross: "400",
                          tax: "50",
                          national_insurance: "20")
    fill_in_forms_until(:check_answers)
  end
end

RSpec.shared_context "with a check containing self-employment data" do
  before do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen(type: "Self-employment income",
                          frequency: "Every 2 weeks",
                          gross: "350",
                          tax: "20",
                          national_insurance: "10")
    fill_in_forms_until(:check_answers)
  end
end

RSpec.shared_context "with a check containing partner employment data" do
  before do
    start_assessment
    fill_in_forms_until(:applicant)
    fill_in_applicant_screen(partner: "Yes")
    fill_in_forms_until(:partner_employment_status)
    fill_in_partner_employment_status_screen(choice: "Employed or self-employed")
    fill_in_partner_income_screen(type: "Self-employment income",
                                  frequency: "Every month",
                                  gross: "1250",
                                  tax: "100",
                                  national_insurance: "67")
    fill_in_forms_until(:check_answers)
  end
end

RSpec.describe "Self-employed flow", type: :feature do
  let(:fixed_arbitrary_date) { Date.new(2023, 2, 15) }

  before { travel_to fixed_arbitrary_date }

  context "when completing an employed check" do
    include_context "with a check containing employment data"

    it "sends the right employment data to CFE", :stub_cfe_calls_with_webmock do
      WebMock.reset!

      stub = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)

        expect(parsed["employment_details"]).to eq(
          [
            {
              "income" => {
                "benefits_in_kind" => 0,
                "frequency" => "weekly",
                "gross" => 400.0,
                "national_insurance" => -20.0,
                "tax" => -50.0,
                "receiving_only_statutory_sick_or_maternity_pay" => false,
              },
            },
          ],
        )
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      click_on "Submit"

      expect(stub).to have_been_requested
    end
  end

  context "when completing a self-employed check" do
    include_context "with a check containing self-employment data"

    it "sends the right self-employment data to CFE", :stub_cfe_calls_with_webmock do
      WebMock.reset!

      stub = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)

        expect(parsed["self_employment_details"]).to eq(
          [
            {
              "income" => {
                "frequency" => "two_weekly",
                "gross" => 350.0,
                "national_insurance" => -10.0,
                "tax" => -20.0,
              },
            },
          ],
        )
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      click_on "Submit"

      expect(stub).to have_been_requested
    end
  end

  context "when completing a partner-employed check" do
    include_context "with a check containing partner employment data"

    it "sends the right partner employment data to CFE", :stub_cfe_calls_with_webmock do
      WebMock.reset!

      stub = stub_request(:post, %r{assessments\z}).with { |request|
        parsed = JSON.parse(request.body)

        expect(parsed["partner"]["self_employment_details"]).to eq(
          [
            {
              "income" => {
                "frequency" => "monthly",
                "gross" => 1250.0,
                "national_insurance" => -67.0,
                "tax" => -100.0,
              },
            },
          ],
        )
      }.to_return(
        body: FactoryBot.build(:api_result, eligible: "eligible").to_json,
        headers: { "Content-Type" => "application/json" },
      )

      click_on "Submit"

      expect(stub).to have_been_requested
    end
  end

  context "when interacting with the CFE API", :end2end do
    context "when completing an employed check" do
      include_context "with a check containing employment data"

      it "shows appropriate monthly income data on the results page" do
        click_on "Submit"

        expect(page).to have_content "Client's monthly income\nAll figures have been converted into a monthly amount.\nEmployment income\n£1,733.33"
        expect(page).to have_content "Income tax\n£216.67"
        expect(page).to have_content "National Insurance\n£86.67"
        expect(page).to have_content "Employment expenses\nA fixed allowance if your client gets a salary or wage\n£45.00"
      end
    end

    context "when completing a self-employed check" do
      include_context "with a check containing self-employment data"

      it "shows appropriate monthly income data on the results page" do
        click_on "Submit"

        expect(page).to have_content "Client's monthly income\nAll figures have been converted into a monthly amount.\nEmployment income\n£758.33"
        expect(page).to have_content "Income tax\n£43.33"
        expect(page).to have_content "National Insurance\n£21.67"
        expect(page).to have_content "Employment expenses\nA fixed allowance if your client gets a salary or wage\n£0.00"
      end
    end

    context "when completing a partner-employed check" do
      include_context "with a check containing partner employment data"

      it "shows appropriate monthly income data on the results page" do
        click_on "Submit"

        expect(page).to have_content "Partner's monthly income\nAll figures have been converted into a monthly amount.\nEmployment income\n£1,250.00"
        expect(page).to have_content "Income tax\n£100.00"
        expect(page).to have_content "National Insurance\n£67.00"
        expect(page).to have_content "Employment expenses\nA fixed allowance if the partner gets a salary or wage\n£0.00"
      end
    end
  end
end
