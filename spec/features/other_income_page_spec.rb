require "rails_helper"

RSpec.describe "Other income Page" do
  let(:income_header) { I18n.t("estimate_flow.other_income.heading") }
  let(:estimate_id) { SecureRandom.uuid }
  let(:mock_connection) do
    instance_double(CfeConnection,
                    api_result: CalculationResult.new(FactoryBot.build(:api_result)),
                    create_assessment_id: nil,
                    create_proceeding_type: nil,
                    create_applicant: nil)
  end

  context "when on check answers screen" do
    before do
      visit_check_answers(passporting: false) do |step|
        case step
        when :other_income
          fill_in "other-income-form-pension-value-field", with: "34"
          select_radio_value("other-income-form", "pension-frequency", "monthly")

          fill_in "other-income-form-property-or-lodger-value-field", with: "45"
          select_radio_value("other-income-form", "property-or-lodger-frequency", "every-week")

          fill_in "other-income-form-friends-or-family-value-field", with: "200"
          select_radio_value("other-income-form", "friends-or-family-frequency", "every-week")

          fill_in "other-income-form-maintenance-value-field", with: "300"
          select_radio_value("other-income-form", "maintenance-frequency", "every-two-weeks")

          fill_in "other-income-form-student-finance-value-field", with: "100"
          fill_in "other-income-form-other-value-field", with: "67"
        end
      end
    end

    it "shows correctly on check answers" do
      within "#field-list-other_income" do
        expect(page).to have_content "Financial help\n£200.00"
        expect(page).to have_content "Maintenance payments from a former partner\n£300.00"
        expect(page).to have_content "Student finance£100.00"
        expect(page).to have_content "Income from a property or lodger\n£45.00"
        expect(page).to have_content "Pension\n£34.00"
        expect(page).to have_content "Other sources£67.00"
      end
    end
  end

  context "when on income screen" do
    before do
      visit estimate_build_estimate_path(estimate_id, :other_income)
    end

    it "shows the correct page" do
      expect(page).to have_content income_header
    end

    context "when I put in valid values" do
      before do
        fill_in "other-income-form-pension-value-field", with: "34"
        select_radio_value("other-income-form", "pension-frequency", "monthly")

        fill_in "other-income-form-property-or-lodger-value-field", with: "45"
        select_radio_value("other-income-form", "property-or-lodger-frequency", "every-week")

        fill_in "other-income-form-friends-or-family-value-field", with: "200"
        select_radio_value("other-income-form", "friends-or-family-frequency", "every-week")

        fill_in "other-income-form-maintenance-value-field", with: "300"
        select_radio_value("other-income-form", "maintenance-frequency", "every-two-weeks")

        fill_in "other-income-form-student-finance-value-field", with: "100"
        fill_in "other-income-form-other-value-field", with: "67"

        click_on "Save and continue"
      end

      it "allows me to proceed" do
        expect(page).not_to have_content income_header
      end
    end

    it "validates if value fields are left blank" do
      click_on "Save and continue"
      expect(page).to have_content("Enter financial help from friends and family, if this does not apply enter 0")
      expect(page).to have_content("Enter maintenance payments from a former partner, if this does not apply enter 0")
      expect(page).to have_content("Enter income from a property or lodger, if this does not apply enter 0")
      expect(page).to have_content("Enter pension, if this does not apply enter 0")
      expect(page).to have_content("Enter student finance, if this does not apply enter 0")
      expect(page).to have_content("Enter income from other sources, if this does not apply enter 0")
    end

    it "validates if value fields are entered above zero and frequencies aren't" do
      fill_in "other-income-form-pension-value-field", with: "0"
      fill_in "other-income-form-property-or-lodger-value-field", with: "100"
      fill_in "other-income-form-friends-or-family-value-field", with: "200"
      fill_in "other-income-form-maintenance-value-field", with: "300"
      fill_in "other-income-form-student-finance-value-field", with: "0"
      fill_in "other-income-form-other-value-field", with: "0"
      click_on "Save and continue"
      expect(page).to have_content("Select frequency of financial help from friends and family")
      expect(page).to have_content("Select frequency of maintenance payments from a former partner")
      expect(page).to have_content("Select frequency of income from a property or lodger")
      expect(page).not_to have_content("Select frequency of pension")
    end
  end

  describe "sending data to CFE" do
    before do
      visit_check_answers(passporting: false) do |step|
        case step
        when :other_income
          fill_in "other-income-form-pension-value-field", with: "0"
          fill_in "other-income-form-property-or-lodger-value-field", with: "0"

          fill_in "other-income-form-friends-or-family-value-field", with: "200"
          select_radio_value("other-income-form", "friends-or-family-frequency", "every-week")

          fill_in "other-income-form-maintenance-value-field", with: "300"
          select_radio_value("other-income-form", "maintenance-frequency", "every-two-weeks")

          fill_in "other-income-form-student-finance-value-field", with: "100"
          fill_in "other-income-form-other-value-field", with: "500"
        end
      end
    end

    it "sends the right data to CFE" do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)

      expect(mock_connection).to receive(:create_regular_payments) do |_cfe_estimate_id, payments|
        credit_payments = payments.select { _1[:operation] == :credit }
        expect(credit_payments.length).to eq 2
        expect(credit_payments.find { _1[:category] == :friends_or_family }[:frequency]).to eq(:weekly)
        expect(credit_payments.find { _1[:category] == :friends_or_family }[:amount]).to eq(200)
        expect(credit_payments.find { _1[:category] == :maintenance_in }[:frequency]).to eq(:two_weekly)
        expect(credit_payments.find { _1[:category] == :maintenance_in }[:amount]).to eq(300)
      end
      expect(mock_connection).to receive(:create_irregular_income) do |_cfe_estimate_id, payments|
        expect(payments.length).to eq 2
        expect(payments.find { _1[:income_type] == "unspecified_source" }[:frequency]).to eq("quarterly")
        expect(payments.find { _1[:income_type] == "unspecified_source" }[:amount]).to eq(500)
        expect(payments.find { _1[:income_type] == "student_loan" }[:frequency]).to eq("annual")
        expect(payments.find { _1[:income_type] == "student_loan" }[:amount]).to eq(100)
      end
      click_on "Submit"
    end
  end

  context "when assessing controlled work", :controlled_flag do
    before do
      visit_check_answers(passporting: false) do |step|
        case step
        when :level_of_help
          select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: "controlled")
          click_on "Save and continue"
        when :other_income
          fill_in "other-income-form-pension-value-field", with: "0"
          fill_in "other-income-form-property-or-lodger-value-field", with: "0"
          fill_in "other-income-form-friends-or-family-value-field", with: "0"
          fill_in "other-income-form-maintenance-value-field", with: "0"
          fill_in "other-income-form-student-finance-value-field", with: "0"
          fill_in "other-income-form-other-value-field", with: "500"
        end
      end
    end

    it "sends a the 'other' amount at a monthly frequency to CFE" do
      allow(CfeConnection).to receive(:connection).and_return(mock_connection)

      expect(mock_connection).to receive(:create_irregular_income) do |_cfe_estimate_id, payments|
        expect(payments.length).to eq 1
        expect(payments[0][:frequency]).to eq("monthly")
        expect(payments[0][:amount]).to eq(500)
      end
      click_on "Submit"
    end
  end
end
