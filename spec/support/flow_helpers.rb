def form_path(step, assessment_code)
  step_path(step_url_fragment: Flow::Handler.url_fragment(step), assessment_code:)
end

def start_assessment
  visit root_path
  click_on "Start now"
end

def fill_in_client_age_screen(choice: "18 to 59")
  confirm_screen "client_age"
  choose choice
  click_on "Save and continue"
end

LEVEL_OF_HELP_CHOICES = {
  certificated: "Civil certificated or licensed legal work",
  controlled: "Civil controlled work or family mediation",
}.freeze

def fill_in_level_of_help_with(value)
  fill_in_level_of_help_screen(choice: LEVEL_OF_HELP_CHOICES.fetch(value))
end

def fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
  confirm_screen "level_of_help"
  choose choice
  click_on "Save and continue"
end

def fill_in_under_18_controlled_legal_rep_screen(choice: "Yes")
  confirm_screen "under_18_clr"
  choose choice
  click_on "Save and continue"
end

def fill_in_aggregated_means_screen(choice: "No")
  confirm_screen "aggregated_means"
  choose choice
  click_on "Save and continue"
end

def fill_in_how_to_aggregate_screen
  click_on "Continue"
end

def fill_in_regular_income_screen(choice: "No")
  confirm_screen "regular_income"
  choose choice
  click_on "Save and continue"
end

def fill_in_under_eighteen_assets_screen(choice: "No")
  confirm_screen "under_eighteen_assets"
  choose choice
  click_on "Save and continue"
end

def fill_in_domestic_abuse_applicant_screen(choice: "No")
  confirm_screen "domestic_abuse_applicant"
  choose choice
  click_on "Save and continue"
end

def fill_in_immigration_or_asylum_screen(choice: "No")
  confirm_screen "immigration_or_asylum"
  choose choice
  click_on "Save and continue"
end

def fill_in_immigration_or_asylum_type_screen(choice: "Asylum")
  confirm_screen "immigration_or_asylum_type"
  choose choice
  click_on "Save and continue"
end

def fill_in_immigration_or_asylum_type_upper_tribunal_screen(choice: "No")
  confirm_screen "immigration_or_asylum_type_upper_tribunal"
  choose choice
  click_on "Save and continue"
end

def fill_in_asylum_support_screen(choice: "No")
  confirm_screen "asylum_support"
  choose choice
  click_on "Save and continue"
end

def fill_in_applicant_screen(partner: "No", passporting: "No")
  confirm_screen "applicant"

  choose partner, name: "applicant_form[partner]"
  choose passporting, name: "applicant_form[passporting]"

  click_on "Save and continue"
end

def fill_in_dependant_details_screen(options = {})
  screen_name = options.fetch(:screen_name, :dependant_details)
  confirm_screen screen_name

  child_dependants = options.fetch(:child_dependants, "No")
  adult_dependants = options.fetch(:adult_dependants, "No")
  choose child_dependants, name: "#{screen_name}_form[child_dependants]"
  choose adult_dependants, name: "#{screen_name}_form[adult_dependants]"
  fill_in "#{screen_name}_form[child_dependants_count]", with: options.fetch(:child_dependants_count, "0") if child_dependants == "Yes"
  fill_in "#{screen_name}_form[adult_dependants_count]", with: options.fetch(:adult_dependants_count, "0") if adult_dependants == "Yes"
  click_on "Save and continue"
end

def fill_in_dependant_income_screen(choice: "No")
  confirm_screen :dependant_income
  choose choice
  click_on "Save and continue"
end

def fill_in_dependant_income_details_screen(frequency: "Every week", amount: "1")
  confirm_screen :dependant_income_details
  choose frequency, name: "dependant_income_model[items][1][frequency]"
  fill_in "dependant_income_model[items][1][amount]", with: amount
  click_on "Save and continue"
end

def fill_in_employment_status_screen(choice: "Unemployed", screen_name: :employment_status)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[employment_status]"
  click_on "Save and continue"
end

def fill_in_income_screen(type: "A salary or wage", frequency: "Every month", gross: "1", tax: "0", national_insurance: "0", screen_name: :income)
  confirm_screen screen_name
  choose type, name: "income_model[items][1][income_type]"
  choose frequency, name: "income_model[items][1][income_frequency]"
  fill_in "income_model[items][1][gross_income]", with: gross
  fill_in "income_model[items][1][income_tax]", with: tax
  fill_in "income_model[items][1][national_insurance]", with: national_insurance
  click_on "Save and continue"
end

def fill_in_housing_benefit_screen(choice: "No", screen_name: :housing_benefit)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[housing_benefit]"
  click_on "Save and continue"
end

def fill_in_housing_benefit_details_screen(screen_name: :housing_benefit_details)
  confirm_screen screen_name
  fill_in "#{screen_name}_form[housing_benefit_value]", with: "1"
  choose "Every week"
  click_on "Save and continue"
end

def fill_in_benefits_screen(choice: "No", screen_name: :benefits)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[receives_benefits]"
  click_on "Save and continue"
end

def fill_in_benefit_details_screen(benefit_type: "A", screen_name: :benefit_details)
  confirm_screen screen_name
  fill_in "1-type", with: benefit_type
  fill_in "1-benefit-amount", with: "1"
  choose "1-frequency-every_week"
  click_on "Save and continue"
end

def fill_in_other_income_screen(screen_name: :other_income, choice: "No", values: {}, frequencies: {})
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[friends_or_family_relevant]"
  fill_in "#{screen_name}_form[friends_or_family_conditional_value]", with: values.fetch(:friends_or_family, "0") if page.text.include?("Amount")
  fill_in "#{screen_name}_form[friends_or_family_frequency]", with: frequencies.fetch(:friends_or_family, "0") if page.text.include?("Frequency?")
  choose choice, name:  "#{screen_name}_form[maintenance_relevant]"
  choose choice, name:  "#{screen_name}_form[property_or_lodger_relevant]"
  choose choice, name:  "#{screen_name}_form[pension_relevant]"
  choose choice, name:  "#{screen_name}_form[student_finance_relevant]"
  choose choice, name:  "#{screen_name}_form[other_relevant]"
  click_on "Save and continue"
end

def fill_in_other_income_screen_with_friends_and_family(screen_name: :other_income)
  confirm_screen screen_name
  choose "Yes", name: "#{screen_name}_form[friends_or_family_relevant]"
  fill_in "#{screen_name}_form[friends_or_family_conditional_value]", with: "1200"
  choose "Every month", name: "#{screen_name}_form[friends_or_family_frequency]"
  choose "No", name:  "#{screen_name}_form[maintenance_relevant]"
  choose "No", name:  "#{screen_name}_form[property_or_lodger_relevant]"
  choose "No", name:  "#{screen_name}_form[pension_relevant]"
  choose "No", name:  "#{screen_name}_form[student_finance_relevant]"
  choose "No", name:  "#{screen_name}_form[other_relevant]"
  click_on "Save and continue"
end

def fill_in_partner_other_income_screen_with_family_and_other
  fill_in_other_income_screen_with_family_and_other(screen_name: :partner_other_income)
end

def fill_in_other_income_screen_with_family_and_student(screen_name: :other_income)
  confirm_screen screen_name
  choose "Yes", name: "#{screen_name}_form[friends_or_family_relevant]"
  fill_in "#{screen_name}_form[friends_or_family_conditional_value]", with: "200"
  choose "Every week", name: "#{screen_name}_form[friends_or_family_frequency]"
  choose "No", name:  "#{screen_name}_form[maintenance_relevant]"
  choose "No", name:  "#{screen_name}_form[property_or_lodger_relevant]"
  choose "No", name:  "#{screen_name}_form[pension_relevant]"
  choose "Yes", name: "#{screen_name}_form[student_finance_relevant]"
  choose "No", name: "#{screen_name}_form[other_relevant]"
  fill_in "#{screen_name}_form[student_finance_conditional_value]", with: "100"
  click_on "Save and continue"
end

def fill_in_other_income_screen_with_family_and_other(screen_name: :other_income)
  confirm_screen screen_name
  choose "Yes", name: "#{screen_name}_form[friends_or_family_relevant]"
  fill_in "#{screen_name}_form[friends_or_family_conditional_value]", with: "200"
  choose "Every week", name: "#{screen_name}_form[friends_or_family_frequency]"
  choose "No", name:  "#{screen_name}_form[maintenance_relevant]"
  choose "No", name:  "#{screen_name}_form[property_or_lodger_relevant]"
  choose "No", name:  "#{screen_name}_form[pension_relevant]"
  choose "No", name:  "#{screen_name}_form[student_finance_relevant]"
  choose "Yes", name: "#{screen_name}_form[other_relevant]"
  fill_in "#{screen_name}_form[other_conditional_value]", with: "100"
  click_on "Save and continue"
end

def fill_in_other_income_screen_with_ineligible_values(screen_name: :other_income)
  confirm_screen screen_name
  choose "Yes", name: "#{screen_name}_form[friends_or_family_relevant]"
  fill_in "#{screen_name}_form[friends_or_family_conditional_value]", with: "3000"
  choose "Every month", name: "#{screen_name}_form[friends_or_family_frequency]"
  choose "No", name:  "#{screen_name}_form[maintenance_relevant]"
  choose "No", name:  "#{screen_name}_form[property_or_lodger_relevant]"
  choose "No", name:  "#{screen_name}_form[pension_relevant]"
  choose "No", name:  "#{screen_name}_form[student_finance_relevant]"
  choose "No", name:  "#{screen_name}_form[other_relevant]"
  click_on "Save and continue"
end

def fill_in_outgoings_screen(screen_name: :outgoings, choice: "No")
  confirm_screen screen_name.to_s
  choose choice, name: "#{screen_name}_form[childcare_payments_relevant]" if page.text.include?("childcare")
  choose choice, name: "#{screen_name}_form[maintenance_payments_relevant]"
  choose choice, name: "#{screen_name}_form[legal_aid_payments_relevant]"
  click_on "Save and continue"
end

def fill_in_outgoings_screen_with_maintenance(screen_name: :outgoings)
  confirm_screen screen_name.to_s
  choose "No", name: "#{screen_name}_form[childcare_payments_relevant]" if page.text.include?("childcare")
  choose "Yes", name: "#{screen_name}_form[maintenance_payments_relevant]"
  fill_in "#{screen_name}_form[maintenance_payments_conditional_value]", with: "800"
  choose "Every month", name: "#{screen_name}_form[maintenance_payments_frequency]"
  choose "No", name: "#{screen_name}_form[legal_aid_payments_relevant]"
  click_on "Save and continue"
end

def fill_in_property_screen(choice: "No", screen_name: :property)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[property_owned]"
  click_on "Save and continue"
end

def fill_in_property_landlord_screen(choice: "Yes", screen_name: :property_landlord)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[property_landlord]"
  click_on "Save and continue"
end

def fill_in_property_entry_screen
  confirm_screen :property_entry
  fill_in "property_entry_form[house_value]", with: "1"
  fill_in "property_entry_form[mortgage]", with: "1" if page.text.include?("How much is left to pay on the mortgage?")
  fill_in "property_entry_form[percentage_owned]", with: "1"
  click_on "Save and continue"
end

def fill_in_housing_shared_who_screen(choice: "Yes")
  confirm_screen :property_landlord
  choose choice
  click_on "Save and continue"
end

def fill_in_shared_ownership_housing_costs_screen(rent: 100, mortgage: 100, housing_benefit: 95)
  confirm_screen :shared_ownership_housing_costs

  choose "Every month", name: "shared_ownership_housing_costs_form[combined_frequency]"
  fill_in "shared_ownership_housing_costs_form[rent]", with: rent
  fill_in "shared_ownership_housing_costs_form[shared_ownership_mortgage]", with: mortgage

  if housing_benefit.positive?
    choose "Yes", name: "shared_ownership_housing_costs_form[housing_benefit_relevant]"
    fill_in "shared_ownership_housing_costs_form[housing_benefit_value]", with: housing_benefit
    choose "Every month", name: "shared_ownership_housing_costs_form[housing_benefit_frequency]"
  else
    choose "No", name: "shared_ownership_housing_costs_form[housing_benefit_relevant]"
  end
  click_on "Save and continue"
end

def fill_in_housing_costs_screen(housing_payments: 0, housing_benefit: 0)
  confirm_screen :housing_costs

  fill_in "housing_costs_form[housing_payments]", with: housing_payments
  choose "Every month", name: "housing_costs_form[housing_payments_frequency]"

  if housing_benefit.positive?
    choose "Yes", name: "housing_costs_form[housing_benefit_relevant]"
    fill_in "housing_costs_form[housing_benefit_value]", with: housing_benefit
    choose "Every month", name: "housing_costs_form[housing_benefit_frequency]"
  else
    choose "No", name: "housing_costs_form[housing_benefit_relevant]"
  end
  click_on "Save and continue"
end

def fill_in_mortgage_or_loan_payment_screen(amount: "100")
  confirm_screen :mortgage_or_loan_payment
  fill_in "mortgage_or_loan_payment_form[housing_loan_payments]", with: amount
  choose "Every month", name: "mortgage_or_loan_payment_form[housing_payments_loan_frequency]"
  click_on "Save and continue"
end

def fill_in_vehicle_screen(choice: "No", screen_name: :vehicle)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[vehicle_owned]"
  click_on "Save and continue"
end

def fill_in_vehicles_details_screen(vehicle_finance: "0")
  confirm_screen :vehicles_details
  fill_in "vehicle_model[items][1][vehicle_value]", with: "1"
  choose (vehicle_finance == "0" ? "No" : "Yes"), name: "vehicle_model[items][1][vehicle_pcp]"
  choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
  choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
  if vehicle_finance != "0"
    fill_in "vehicle_model[items][1][vehicle_finance]", with: vehicle_finance
  end
  click_on "Save and continue"
end

def fill_in_assets_screen(bank_account_value: "0", screen_name: :assets, form_name: :client_assets, values: {}, disputed: [])
  confirm_screen screen_name
  fill_in "bank_account_model[items][1][amount]", with: bank_account_value

  # check for presence of conditional reveal for investments
  if all("##{form_name.to_s.dasherize}-form-investments-relevant-true-field", visible: false).any?
    if values.key? :investments
      choose "Yes", name: "#{form_name}_form[investments_relevant]"
      fill_in "#{form_name}_form[investments]", with: values.fetch(:investments)
    else
      choose "No", name: "#{form_name}_form[investments_relevant]"
    end
  else
    fill_in "#{form_name}_form[investments]", with: values.fetch(:investments, "0")
  end

  # check for presence of conditional reveal for valuables
  if all("##{form_name.to_s.dasherize}-form-valuables-relevant-true-field", visible: false).any?
    if values.key? :valuables
      choose "Yes", name: "#{form_name}_form[valuables_relevant]"
      fill_in "#{form_name}_form[valuables]", with: values.fetch(:valuables)
    else
      choose "No", name: "#{form_name}_form[valuables_relevant]"
    end
  else
    fill_in "#{form_name}_form[valuables]", with: values.fetch(:valuables, "0")
  end

  disputed.each do |disputed_item|
    check "This asset is a subject matter of dispute",
          id: "#{form_name.to_s.dasherize}-form-#{disputed_item}-in-dispute-true-field"
  end

  click_on "Save and continue"
end

def fill_in_client_income_screens
  fill_in_housing_benefit_screen
  fill_in_benefits_screen
  fill_in_other_income_screen
  fill_in_outgoings_screen
end

def fill_in_client_capital_screens
  fill_in_property_screen
  fill_in_vehicle_screen
  fill_in_assets_screen
end

def fill_in_partner_details_screen(choices = {})
  confirm_screen "partner_details"
  choose choices.fetch(:over_60, "No"), name: "partner_details_form[over_60]"
  click_on "Save and continue"
end

def fill_in_partner_employment_status_screen(choice: "Unemployed")
  fill_in_employment_status_screen(screen_name: :partner_employment_status, choice:)
end

def fill_in_partner_income_screen(type: "A salary or wage", frequency: "Every month", gross: "1", tax: "0", national_insurance: "0")
  fill_in_income_screen(type:, frequency:, gross:, tax:, national_insurance:, screen_name: :partner_income)
end

def fill_in_partner_benefits_screen(choice: "No")
  fill_in_benefits_screen(screen_name: :partner_benefits, choice:)
end

def fill_in_partner_benefit_details_screen(benefit_type: "A")
  fill_in_benefit_details_screen(benefit_type:, screen_name: :partner_benefit_details)
end

def fill_in_partner_other_income_screen(values: {}, frequencies: {})
  fill_in_other_income_screen(screen_name: :partner_other_income, values:, frequencies:)
end

def fill_in_partner_outgoings_screen
  fill_in_outgoings_screen(screen_name: :partner_outgoings)
end

def fill_in_partner_assets_screen(values: {})
  fill_in_assets_screen(screen_name: :partner_assets, form_name: :partner_assets, values:)
end

def fill_in_partner_income_screens
  fill_in_partner_benefits_screen
  fill_in_partner_other_income_screen
  fill_in_partner_outgoings_screen
end

def fill_in_partner_capital_screens
  fill_in_partner_assets_screen
end

def fill_in_additional_property_screen(choice: "No")
  fill_in_property_screen(screen_name: :additional_property, choice:)
end

def fill_in_additional_property_details_screen(screen_name: :additional_property_details)
  confirm_screen screen_name
  fill_in "additional_property_model[items][1][house_value]", with: "1"
  fill_in "additional_property_model[items][1][mortgage]", with: "1" if page.text.include?("How much is left to pay on the mortgage?")
  fill_in "additional_property_model[items][1][percentage_owned]", with: "1"
  click_on "Save and continue"
end

def fill_in_partner_additional_property_screen(choice: "No")
  fill_in_property_screen(screen_name: :partner_additional_property, choice:)
end

def fill_in_partner_additional_property_details_screen
  fill_in_additional_property_details_screen(screen_name: :partner_additional_property_details)
end

def fill_in_ineligible_gross_income_screen(choice: "Resume check")
  confirm_ineligible_gross_income_screen
  click_on choice
end

def confirm_ineligible_gross_income_screen
  path = page.current_path
  expect(path).to include("gross-monthly-over-limit")
end

def confirm_screen(expected)
  path = page.current_path
  if expected.to_sym == :check_answers
    expect(path).to start_with "/check-answers"
  elsif expected.to_sym == :cannot_use_service
    expect(path).to start_with "/cannot-use-service"
  else
    expect(path).to start_with "/#{Flow::Handler.url_fragment(expected.to_sym)}"
  end
end

def fill_in_forms_until(target)
  current_page = nil
  loop do
    new_current_page = current_path.split("/").map(&:presence).compact.first
    raise "Infinite loop detected on screen #{current_page}" if current_page == new_current_page

    current_page = new_current_page

    step = Flow::Handler.step_from_url_fragment(current_page)
    break if step.to_s == target.to_s || current_path.starts_with?("/check-answers")

    send("fill_in_#{step}_screen")
  end
end
