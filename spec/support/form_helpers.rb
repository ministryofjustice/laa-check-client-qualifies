def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def select_radio_value(form, field, value)
  find(:css, "##{form}-#{field}-#{value}-field").click
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
  click_checkbox("proceeding-type-form-proceeding-type", "se003")
  click_on "Save and continue"
  select_boolean_value("partner-form", "partner", partner)
  click_on "Save and continue"
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

def skip_outgoings_form
  fill_in "outgoings-form-housing-payments-value-field", with: "0"
  fill_in "outgoings-form-childcare-payments-value-field", with: "0"
  fill_in "outgoings-form-legal-aid-payments-value-field", with: "0"
  fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
  click_on "Save and continue"
end

def progress_to_submit_from_outgoings
  skip_outgoings_form

  click_checkbox("property-form-property-owned", "none")
  click_on "Save and continue"
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  progress_to_submit_from_vehicle_form
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

def complete_incomes_screen
  fill_in "other-income-form-friends-or-family-value-field", with: "100"
  select_radio_value("other-income-form", "friends-or-family-frequency", "monthly")
  fill_in "other-income-form-maintenance-value-field", with: "200"
  select_radio_value("other-income-form", "maintenance-frequency", "monthly")
  fill_in "other-income-form-property-or-lodger-value-field", with: "300"
  select_radio_value("other-income-form", "property-or-lodger-frequency", "monthly")
  fill_in "other-income-form-pension-value-field", with: "400"
  select_radio_value("other-income-form", "pension-frequency", "monthly")
  fill_in "other-income-form-student-finance-value-field", with: "0"
  fill_in "other-income-form-other-value-field", with: "500"
  click_on "Save and continue"
end

def skip_assets_form
  fill_in "assets-form-property-value-field", with: "0"
  fill_in "assets-form-savings-field", with: "0"
  fill_in "assets-form-investments-field", with: "0"
  fill_in "assets-form-valuables-field", with: "0"
  click_on "Save and continue"
end

def visit_check_answer_with_passporting_benefit
  visit_applicant_page
  fill_in_applicant_screen_with_passporting_benefits
  click_on "Save and continue"

  click_checkbox("property-form-property-owned", "none")
  click_on "Save and continue"
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  click_on "Save and continue"
  skip_assets_form
end

def visit_check_answer_without_passporting_benefit
  visit_applicant_page
  fill_in_applicant_screen_without_passporting_benefits
  click_on "Save and continue"
  complete_dependants_section

  select_boolean_value("benefits-form", :add_benefit, false)
  click_on("Save and continue")
  complete_incomes_screen
  skip_outgoings_form

  click_checkbox("property-form-property-owned", "none")
  click_on "Save and continue"
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  click_on "Save and continue"
  skip_assets_form
end
