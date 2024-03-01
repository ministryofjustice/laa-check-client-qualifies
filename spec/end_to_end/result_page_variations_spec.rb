require "rails_helper"

RSpec.describe "Results page variations", :end2end, type: :feature do
  it "shows an ineligible result if the client's gross income is above the threshold" do
    start_assessment
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen(gross: "1500", frequency: "Every month")
    fill_in_forms_until(:other_income)
    fill_in_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every month" })
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    key_lines = ["Your client is not likely to qualify financially for civil legal aid based on the information you entered.",
                 "Client's monthly income\nAll figures have been converted into a monthly amount.",
                 "Employment income\n£1,500.00",
                 "Financial help from friends and family\n£1,200.00",
                 "Total monthly income£2,700.00Monthly income upper limit£2,657.00",
                 "Your client’s total monthly income exceeds the upper limit. This means they do not qualify for legal aid"]

    key_lines.each { expect(page).to have_content _1 }
  end

  it "requests income and capital contributions when appropriate" do
    start_assessment
    fill_in_forms_until(:level_of_help)
    fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
    fill_in_forms_until(:employment_status)
    fill_in_employment_status_screen(choice: "Employed or self-employed")
    fill_in_income_screen(gross: "1500", frequency: "Every month")
    fill_in_forms_until(:outgoings)
    fill_in_outgoings_screen(values: { maintenance: "800" }, frequencies: { maintenance: "Every month" })
    fill_in_forms_until(:assets)
    fill_in_assets_screen(values: { valuables: "4000" })
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    key_lines = ["Your client is likely to qualify financially for civil legal aid based on the information you have entered.",
                 "We estimate they will have to pay towards the costs of their case:\n",
                 "£149.15 per month from their disposable income - these contributions will continue for the duration of the case, however long it lasts£1,000.00 lump sum payment from their disposable capital - any capital contribution will not exceed the likely costs of their case and they might pay less than this amount\n",
                 "Disposable income and Capital limitsLower limitUpper limitDisposable monthly income£315£733Capital£3,000£8,000",
                 "Total monthly income£1,500.00Monthly income upper limit£2,657.00",
                 "Maintenance payments to a former partner\n£800.00",
                 "Employment expenses\nA fixed allowance if your client gets a salary or wage\n£45.00",
                 "Total monthly income minus total monthly outgoings\n£655.00Disposable monthly income upper limit£733.00",
                 "Investments and valuables\n£4,000.00",
                 "Total assessed disposable capital£4,000.00Disposable capital upper limit£8,000.00"]

    key_lines.each { expect(page).to have_content _1 }
  end

  it "disregards SMOD capital" do
    start_assessment
    fill_in_forms_until(:assets)
    fill_in_assets_screen(values: { valuables: "40,000" }, disputed: %i[valuables])
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    key_lines = ["Your client is likely to qualify financially for civil legal aid",
                 "Investments and valuables\n£40,000.00",
                 "Disputed asset disregard\nEqual to the assessed value of all assets marked as disputed and capped at £100,000\n-£40,000.00",
                 "Total assessed disposable capital£0.00"]

    key_lines.each { expect(page).to have_content _1 }
  end

  it "disregards capital when the client is over 60" do
    start_assessment
    fill_in_client_age_screen(choice: "60 or over")
    fill_in_forms_until(:applicant)
    fill_in_forms_until(:assets)
    fill_in_assets_screen(values: { valuables: "102,000" })
    fill_in_forms_until(:check_answers)
    click_on "Submit"

    key_lines = ["Your client is likely to qualify financially for civil legal aid",
                 "Investments and valuables\n£102,000.00",
                 "60 or over disregard (also known as pensioner disregard)\nApplied to total capital up to a maximum of £100,000\n-£100,000.00",
                 "Total assessed disposable capital£2,000.00"]

    key_lines.each { expect(page).to have_content _1 }
  end

  # context "when early eligibility journey is enabled and ineligible on gross_income", :early_eligibility_flag do
  #   before do
  #     allow(CfeService).to receive(:result).and_return(instance_double(CfeResult, ineligible_gross_income?: true,
  #                                                                      gross_income_excess: 1000))
  #   end
  #
  #   it "does not show the disposable or capital result" do
  #     start_assessment
  #     fill_in_forms_until(:applicant)
  #     fill_in_applicant_screen(partner: "No", passporting: "No")
  #     fill_in_dependant_details_screen
  #     fill_in_employment_status_screen(choice: "Employed or self-employed")
  #     fill_in_income_screen(gross: "8000", frequency: "Every month")
  #     fill_in_forms_until(:other_income)
  #     fill_in_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every week" })
  #     fill_in_ineligible_gross_income_screen(choice: "Go to summary")
  #     confirm_screen("check_answers")
  #     click_on "Submit"
  #
  #     key_lines = ["Your client does not qualify for civil legal aid, for controlled work and family mediation",
  #                  "Disposable monthly income\nNot assessed\nThis was not assessed because it would not change the overall result ",
  #                  "Disposable capital\nNot assessed\nThis was not assessed because it would not change the overall result ",]
  #
  #     key_lines.each { expect(page).to have_content _1 }
  #   end
  #
  #   it "shows the disposable and capital result if I continue with the check" do
  #     start_assessment
  #     fill_in_forms_until(:applicant)
  #     fill_in_applicant_screen(partner: "No", passporting: "No")
  #     fill_in_dependant_details_screen
  #     fill_in_employment_status_screen(choice: "Employed or self-employed")
  #     fill_in_income_screen(gross: "8000", frequency: "Every month")
  #     fill_in_forms_until(:other_income)
  #     fill_in_other_income_screen(values: { friends_or_family: "1200" }, frequencies: { friends_or_family: "Every week" })
  #     fill_in_ineligible_gross_income_screen(choice: "Add more details")
  #     fill_in_forms_until(:check_answers)
  #     confirm_screen("check_answers")
  #     click_on "Submit"
  #
  #     key_lines = ["Your client does not qualify for civil legal aid, for controlled work and family mediation",
  #                  "Disposable monthly income\nNot assessed\nThis was not assessed because it would not change the overall result ",
  #                  "Disposable capital\nNot assessed\nThis was not assessed because it would not change the overall result ",]
  #
  #     key_lines.each { expect(page).to have_content _1 }
  #   end
  # end
end
