def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def select_radio_value(form, field, value)
  fieldname = value.to_s.tr("_", "-")
  find("label[for=#{"#{form}-#{field}"}-#{fieldname}-field]").click
end

def fill_in_applicant_screen_with_passporting_benefits
  fill_in_applicant_screen_without_passporting_benefits
  select_applicant_boolean(:passporting, true)
end

def fill_in_applicant_screen_without_passporting_benefits
  %i[over_60 employed passporting].each do |attribute|
    select_applicant_boolean(attribute, false)
  end
end

def add_applicant_partner_answers(employed: false, over_60: false)
  select_applicant_boolean(:partner_employed, employed)
  select_applicant_boolean(:partner_over_60, over_60)
end

def select_boolean_value(form_name, field, value)
  fieldname = field.to_s.tr("_", "-")
  if value
    find("label[for=#{form_name}-#{fieldname}-true-field]").click
  else
    find("label[for=#{form_name}-#{fieldname}-field]").click
  end
end

def click_checkbox(form_name, field)
  fieldname = field.to_s.tr("_", "-")
  find("label[for=#{form_name}-#{fieldname}-field]").click
end

def visit_applicant_page(partner: false)
  visit new_estimate_path
  click_on "Reject additional cookies"
  select_radio_value("proceeding-type-form", "proceeding-type", "se003")
  click_on "Save and continue"

  if Flipper.enabled?(:partner)
    select_boolean_value("partner-form", "partner", partner)
    click_on "Save and continue"
  end
end

def visit_applicant_page_with_partner
  visit_applicant_page(partner: true)
end

def complete_dependants_section
  select_boolean_value("dependants-form", :dependants, false)
  click_on "Save and continue"
end

def progress_to_submit_from_vehicle_form
  click_on "Save and continue"
  skip_assets_form
  click_on "Submit"
end

def skip_outgoings_form(subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  fill_in "#{prefix}outgoings-form-housing-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-childcare-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-legal-aid-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-maintenance-payments-value-field", with: "0"
  click_on "Save and continue"
end

def progress_to_submit_from_outgoings
  skip_outgoings_form
  skip_property_form
  skip_vehicle_form
  skip_assets_form
  click_on "Submit"
end

def progress_to_submit_from_benefits
  select_boolean_value("benefits-form", :add_benefit, true)
  click_on "Save and continue"
  fill_in "Benefit type", with: "Child benefit"
  fill_in "Enter amount", with: "150"
  choose "Every week"
  click_on "Save and continue"
  select_boolean_value("benefits-form", :add_benefit, false)
  click_on("Save and continue")
  progress_to_submit_from_incomes
end

def progress_to_submit_from_incomes
  complete_incomes_screen
  progress_to_submit_from_outgoings
end

def complete_incomes_screen(subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  fill_in "#{prefix}other-income-form-friends-or-family-value-field", with: "100"
  select_radio_value("#{prefix}other-income-form", "friends-or-family-frequency", "monthly")
  fill_in "#{prefix}other-income-form-maintenance-value-field", with: "200"
  select_radio_value("#{prefix}other-income-form", "maintenance-frequency", "monthly")
  fill_in "#{prefix}other-income-form-property-or-lodger-value-field", with: "300"
  select_radio_value("#{prefix}other-income-form", "property-or-lodger-frequency", "monthly")
  fill_in "#{prefix}other-income-form-pension-value-field", with: "400"
  select_radio_value("#{prefix}other-income-form", "pension-frequency", "monthly")
  fill_in "#{prefix}other-income-form-student-finance-value-field", with: "0"
  fill_in "#{prefix}other-income-form-other-value-field", with: "500"
  click_on "Save and continue"
end

def skip_assets_form(subject: :client)
  fill_in "#{subject}-assets-form-property-value-field", with: "0"
  fill_in "#{subject}-assets-form-savings-field", with: "0"
  fill_in "#{subject}-assets-form-investments-field", with: "0"
  fill_in "#{subject}-assets-form-valuables-field", with: "0"
  click_on "Save and continue"
end

def skip_property_form
  select_radio_value("property-form", "property-owned", "none")
  click_on "Save and continue"
end

def skip_partner_property_form
  select_radio_value("partner-property-form", "property-owned", "none")
  click_on "Save and continue"
end

def skip_vehicle_form
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  click_on "Save and continue"
end

def skip_partner_vehicle_form
  select_boolean_value("partner-vehicle-form", :vehicle_owned, false)
  click_on "Save and continue"
end

def visit_check_answer_with_passporting_benefit
  visit_applicant_page
  fill_in_applicant_screen_with_passporting_benefits
  click_on "Save and continue"

  skip_property_form
  skip_vehicle_form
  skip_assets_form
end

def visit_check_answer_without_passporting_benefit
  visit_applicant_page
  fill_in_applicant_screen_without_passporting_benefits
  click_on "Save and continue"
  travel_from_dependants_to_past_client_assets
end

def travel_from_dependants_to_past_client_assets
  complete_dependants_section
  select_boolean_value("benefits-form", :add_benefit, false)
  click_on("Save and continue")
  complete_incomes_screen
  skip_outgoings_form

  skip_property_form
  skip_vehicle_form
  skip_assets_form
end

def fill_in_employment_form(subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  fill_in "#{prefix}employment-form-gross-income-field", with: 1000
  fill_in "#{prefix}employment-form-income-tax-field", with: 100
  fill_in "#{prefix}employment-form-national-insurance-field", with: 50
  select_radio_value("#{prefix}employment-form", "frequency", "monthly")
  click_on "Save and continue"
end

def visit_check_answer_with_partner
  visit_applicant_page_with_partner
  fill_in_applicant_screen_without_passporting_benefits
  add_applicant_partner_answers(employed: true)
  click_on "Save and continue"
  travel_from_dependants_to_past_client_assets
  fill_in_employment_form(subject: :partner)
  select_boolean_value("partner-benefits-form", :add_benefit, true)
  click_on "Save and continue"
  fill_in "Benefit type", with: "Child benefit"
  fill_in "Enter amount", with: "150"
  choose "Every week"
  click_on "Save and continue"
  select_boolean_value("partner-benefits-form", :add_benefit, false)
  click_on "Save and continue"
  complete_incomes_screen(subject: :partner)
  skip_outgoings_form(subject: :partner)
  skip_partner_property_form
  select_boolean_value("partner-vehicle-form", "vehicle_owned", true)
  click_on "Save and continue"
  fill_in "partner-vehicle-details-form-vehicle-value-field", with: 5_000
  select_boolean_value("partner-vehicle-details-form", :vehicle_in_regular_use, true)
  select_boolean_value("partner-vehicle-details-form", :vehicle_over_3_years_ago, true)
  select_boolean_value("partner-vehicle-details-form", :vehicle_pcp, false)
  click_on "Save and continue"
  skip_assets_form(subject: :partner)
end
