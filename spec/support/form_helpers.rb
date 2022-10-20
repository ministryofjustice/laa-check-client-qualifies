def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def fill_in_applicant_screen_with_passporting_benefits
  fill_in_applicant_screen_without_passporting_benefits
  select_applicant_boolean(:passporting, true)
end

def fill_in_applicant_screen_without_passporting_benefits
  %i[over_60 dependants employed passporting].each do |attribute|
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

def visit_applicant_page
  visit new_estimate_path
  click_on "Reject additional cookies"
  click_checkbox("proceeding-type-form-proceeding-type", "se003")
  click_on "Save and continue"
end

def progress_to_submit_from_vehicle_form
  click_on "Save and continue"
  click_checkbox("assets-form-assets", "none")
  click_on "Save and continue"
  click_on "Submit"
end

def progress_to_submit_from_outgoings
  fill_in "outgoings-form-housing-payments-value-field", with: "0"
  fill_in "outgoings-form-childcare-payments-value-field", with: "0"
  fill_in "outgoings-form-legal-aid-payments-value-field", with: "0"
  fill_in "outgoings-form-maintenance-payments-value-field", with: "0"
  click_on "Save and continue"

  click_checkbox("property-form-property-owned", "none")
  click_on "Save and continue"
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  progress_to_submit_from_vehicle_form
end

def progress_to_submit_from_benefits
  find(:css, "#benefits-form-add-benefit-true-field").click
  click_on "Save and continue"
  fill_in "Benefit type", with: "Child benefit"
  fill_in "Enter amount", with: "150"
  choose "Every week"
  click_on "Save and continue"
  find(:css, "#benefits-form-add-benefit-field").click
  click_on("Save and continue")
  progress_to_submit_from_incomes
end

def progress_to_submit_from_incomes
  click_checkbox("monthly-income-form-monthly-incomes", "friends_or_family")
  fill_in "monthly-income-form-friends-or-family-field", with: "100"
  click_checkbox("monthly-income-form-monthly-incomes", "maintenance")
  fill_in "monthly-income-form-maintenance-field", with: "200"
  click_checkbox("monthly-income-form-monthly-incomes", "property_or_lodger")
  fill_in "monthly-income-form-property-or-lodger-field", with: "300"
  click_checkbox("monthly-income-form-monthly-incomes", "pension")
  fill_in "monthly-income-form-pension-field", with: "400"
  click_checkbox("monthly-income-form-monthly-incomes", "other")
  fill_in "monthly-income-form-other-field", with: "500"
  click_on "Save and continue"
  progress_to_submit_from_outgoings
end
