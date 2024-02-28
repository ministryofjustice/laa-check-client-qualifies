require "rails_helper"

RSpec.describe "Invalid session", type: :feature do
  it "tells me if CfeService thinks my answers are invalid" do
    allow(CfeService).to receive(:call).and_raise(Cfe::InvalidSessionError.new(DomesticAbuseApplicantForm.new))
    expect(ErrorService).to receive(:call)

    start_assessment
    fill_in_forms_until(:check_answers)
    click_on "Submit"
    expect(page).to have_content "Your answers have been deleted"
  end

  it "tells me if CfeService thinks my answers are invalid", :early_eligibility_flag do
    allow(CfeService).to receive(:result).and_raise(Cfe::InvalidSessionError.new(DomesticAbuseApplicantForm.new))
    expect(ErrorService).to receive(:call)

    start_assessment
    fill_in_forms_until(:other_income)
    fill_in_other_income_screen
    expect(page).to have_content "Your answers have been deleted"
  end
end
