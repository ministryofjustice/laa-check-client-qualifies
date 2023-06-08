def start_assessment
  visit root_path
  click_on "Start now"
end

def fill_in_provider_users_screen(choice: "Yes")
  confirm_screen "provider_users"
  choose choice
  click_on "Save and continue"
end

def fill_in_level_of_help_screen(choice: "Civil certificated or licensed legal work")
  confirm_screen "level_of_help"
  choose choice
  click_on "Save and continue"
end

def fill_in_matter_type_screen(choice: "Another category of law")
  confirm_screen "matter_type"
  choose choice
  click_on "Save and continue"
end

def fill_in_asylum_support_screen(choice: "No")
  confirm_screen "asylum_support"
  choose choice
  click_on "Save and continue"
end

def fill_in_applicant_screen(choices = {})
  confirm_screen "applicant"

  choose choices.fetch(:over_60, "No"), name: "applicant_form[over_60]"
  choose choices.fetch(:partner, "No"), name: "applicant_form[partner]"
  choose choices.fetch(:employed, "Unemployed"), name: "applicant_form[employment_status]"
  choose choices.fetch(:passporting, "No"), name: "applicant_form[passporting]"
  click_on "Save and continue"
end

def fill_in_applicant_screen_no_employment_question(choices = {})
  confirm_screen "applicant"

  choose choices.fetch(:over_60, "No"), name: "applicant_form[over_60]"
  choose choices.fetch(:partner, "No"), name: "applicant_form[partner]"
  choose choices.fetch(:passporting, "No"), name: "applicant_form[passporting]"
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

def fill_in_employment_status_screen(choice: "Employed or self-employed", screen_name: :employment_status)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[employment_status]"
  click_on "Save and continue"
end

def fill_in_employment_screen(screen_name: :employment)
  confirm_screen screen_name
  fill_in "#{screen_name}_form[gross_income]", with: "1"
  fill_in "#{screen_name}_form[income_tax]", with: "0"
  fill_in "#{screen_name}_form[national_insurance]", with: "0"
  choose "Every week"
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

def fill_in_other_income_screen(screen_name: :other_income, values: {}, frequencies: {})
  confirm_screen screen_name
  fill_in "#{screen_name}_form[friends_or_family_value]", with: values.fetch(:friends_or_family, "0")
  fill_in "#{screen_name}_form[maintenance_value]", with: values.fetch(:maintenance, "0")
  fill_in "#{screen_name}_form[property_or_lodger_value]", with: values.fetch(:property_or_lodger, "0")
  fill_in "#{screen_name}_form[pension_value]", with: values.fetch(:pension, "0")
  fill_in "#{screen_name}_form[student_finance_value]", with: values.fetch(:student_finance, "0")
  fill_in "#{screen_name}_form[other_value]", with: values.fetch(:other, "0")

  frequencies.each do |k, v|
    choose v, name: "#{screen_name}_form[#{k}_frequency]"
  end
  click_on "Save and continue"
end

def fill_in_outgoings_screen(screen_name: :outgoings)
  confirm_screen screen_name.to_s
  fill_in "#{screen_name}_form[housing_payments_value]", with: "0" if page.body.include?("housing_payments_value")
  fill_in "#{screen_name}_form[childcare_payments_value]", with: "0"
  fill_in "#{screen_name}_form[maintenance_payments_value]", with: "0"
  fill_in "#{screen_name}_form[legal_aid_payments_value]", with: "0"
  click_on "Save and continue"
end

def fill_in_property_screen(choice: "No", screen_name: :property)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[property_owned]"
  click_on "Save and continue"
end

def fill_in_property_entry_screen(screen_name: :property_entry, form_name: :client_property_entry)
  confirm_screen screen_name
  fill_in "#{form_name}_form[house_value]", with: "1"
  fill_in "#{form_name}_form[mortgage]", with: "1" if page.text.include?("How much is left to pay on the mortgage?")
  fill_in "#{form_name}_form[percentage_owned]", with: "1"
  choose "No", name: "#{form_name}_form[joint_ownership]" if page.text.include?("Is the property joint owned with their partner?")
  click_on "Save and continue"
end

def fill_in_housing_costs_screen
  confirm_screen :housing_costs
  fill_in "housing_costs_form[housing_payments]", with: "0"
  choose "Every month", name: "housing_costs_form[housing_payments_frequency]"
  fill_in "housing_costs_form[housing_benefit_value]", with: "0"
  choose "Every month", name: "housing_costs_form[housing_benefit_frequency]"
  click_on "Save and continue"
end

def fill_in_mortgage_or_loan_payment_screen
  confirm_screen :mortgage_or_loan_payment
  fill_in "mortgage_or_loan_payment_form[housing_loan_payments]", with: "100"
  choose "Every month", name: "mortgage_or_loan_payment_form[housing_payments_loan_frequency]"
  click_on "Save and continue"
end

def fill_in_vehicle_screen(choice: "No", screen_name: :vehicle)
  confirm_screen screen_name
  choose choice, name: "#{screen_name}_form[vehicle_owned]"
  click_on "Save and continue"
end

def fill_in_vehicle_details_screen(screen_name: :vehicle_details, form_name: :client_vehicle_details, vehicle_finance: "0")
  confirm_screen screen_name
  fill_in "#{form_name}_form[vehicle_value]", with: "1"
  choose (vehicle_finance == "0" ? "No" : "Yes"), name: "#{form_name}_form[vehicle_pcp]"
  choose "No", name: "#{form_name}_form[vehicle_over_3_years_ago]"
  choose "No", name: "#{form_name}_form[vehicle_in_regular_use]"
  fill_in "#{form_name}_form[vehicle_finance]", with: vehicle_finance
  click_on "Save and continue"
end

def fill_in_vehicles_details_screen(vehicle_finance: "0")
  fill_in "vehicle_model[items][1][vehicle_value]", with: "1234"
  choose (vehicle_finance == "0" ? "No" : "Yes"), name: "vehicle_model[items][1][vehicle_pcp]"
  choose "No", name: "vehicle_model[items][1][vehicle_over_3_years_ago]"
  choose "No", name: "vehicle_model[items][1][vehicle_in_regular_use]"
  fill_in "vehicle_model[items][1][vehicle_finance]", with: vehicle_finance
  click_on "Save and continue"
end

def fill_in_assets_screen(screen_name: :assets, form_name: :client_assets, values: {})
  confirm_screen screen_name
  fill_in "#{form_name}_form[property_value]", with: values.fetch(:property, "0") if page.body.include?("property_value")
  fill_in "#{form_name}_form[savings]", with: values.fetch(:savings, "0")
  fill_in "#{form_name}_form[investments]", with: values.fetch(:investments, "0")
  fill_in "#{form_name}_form[valuables]", with: values.fetch(:valuables, "0")
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
  choose choices.fetch(:employed, "Unemployed"), name: "partner_details_form[employment_status]" if page.text.include?("What is the partner's employment status?")
  click_on "Save and continue"
end

def fill_in_partner_dependant_details_screen(options = {})
  fill_in_dependant_details_screen(options.merge(screen_name: :partner_dependant_details))
end

def fill_in_partner_employment_screen
  fill_in_employment_screen(screen_name: :partner_employment)
end

def fill_in_partner_housing_benefit_screen(choice: "No")
  fill_in_housing_benefit_screen(choice:, screen_name: :partner_housing_benefit)
end

def fill_in_partner_housing_benefit_details_screen
  fill_in_housing_benefit_details_screen(screen_name: :partner_housing_benefit_details)
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

def fill_in_partner_property_screen(choice: "No")
  fill_in_property_screen(screen_name: :partner_property, choice:)
end

def fill_in_partner_property_entry_screen
  fill_in_property_entry_screen(screen_name: :partner_property_entry, form_name: :partner_property_entry)
end

def fill_in_partner_vehicle_screen(choice: "No")
  fill_in_vehicle_screen(screen_name: :partner_vehicle, choice:)
end

def fill_in_partner_vehicle_details_screen
  fill_in_vehicle_details_screen(screen_name: :partner_vehicle_details, form_name: :partner_vehicle_details)
end

def fill_in_partner_assets_screen(values: {})
  fill_in_assets_screen(screen_name: :partner_assets, form_name: :partner_assets, values:)
end

def fill_in_partner_income_screens
  fill_in_partner_housing_benefit_screen
  fill_in_partner_benefits_screen
  fill_in_partner_other_income_screen
  fill_in_partner_outgoings_screen
end

def fill_in_partner_capital_screens
  fill_in_partner_property_screen
  fill_in_partner_vehicle_screen
  fill_in_partner_assets_screen
end

def fill_in_additional_property_screen(choice: "No")
  fill_in_property_screen(screen_name: :additional_property, choice:)
end

def fill_in_additional_property_details_screen
  fill_in_property_entry_screen(screen_name: :additional_property_details, form_name: :additional_property_details)
end

def fill_in_partner_additional_property_screen(choice: "No")
  fill_in_property_screen(screen_name: :partner_additional_property, choice:)
end

def fill_in_partner_additional_property_details_screen
  fill_in_property_entry_screen(screen_name: :partner_additional_property_details, form_name: :partner_additional_property_details)
end

def confirm_screen(expected)
  path = page.current_path
  expect(path).to end_with expected.to_s
end

def fill_in_forms_until(target)
  current_page = nil
  loop do
    new_current_page = current_path.split("/").last.to_sym
    raise "Infinite loop detected on screen #{current_page}" if current_page == new_current_page

    current_page = new_current_page
    break if current_page == target

    send("fill_in_#{current_page}_screen")
  end
end
