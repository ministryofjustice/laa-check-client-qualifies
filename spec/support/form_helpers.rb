def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def select_radio_value(form, field, value)
  select_radio(page:, form:, field:, value:)
end

def fill_in_applicant_screen_without_passporting_benefits(partner: true)
  applicant_without_passporting(page:, partner:)
end

def skip_dependants_form
  select_boolean_value("dependant-details-form", :child_dependants, false)
  select_boolean_value("dependant-details-form", :adult_dependants, false)
  click_on "Save and continue"
end

def add_applicant_partner_answers(employed: false, over_60: false)
  select_radio_value("partner-details-form", :employed, employed)
  select_radio_value("partner-details-form", :over_60, over_60)
end

def select_boolean_value(form_name, field, value)
  select_boolean(page:, form_name:, field:, value:)
end

def click_checkbox(form_name, field)
  fieldname = field.to_s.tr("_", "-")
  find("label[for=#{form_name}-#{fieldname}-field]").click
end

def visit_first_page
  visit new_estimate_path
  click_on "Reject additional cookies"
end

def visit_check_answer_with_partner
  visit_check_answers(passporting: false, partner: true) do |step|
    case step
    when :partner_details
      select_boolean_value("partner-details-form", :over_60, false)
      select_radio(page:, form: "partner-details-form", field: "employment-status", value: "in_work")
    when :partner_employment
      fill_in "partner-employment-form-gross-income-field", with: 1000
      fill_in "partner-employment-form-income-tax-field", with: 100
      fill_in "partner-employment-form-national-insurance-field", with: 50
      select_radio_value("partner-employment-form", "frequency", "monthly")
    when :partner_benefits
      select_boolean_value("partner-benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit name", with: "Child benefit"
      fill_in "Enter amount", with: "150"
      choose "Every week"
      click_on "Save and continue"
      select_boolean_value("partner-benefits-form", :add_benefit, false)
    when :partner_vehicle
      select_boolean_value("partner-vehicle-form", "vehicle_owned", true)
      click_on "Save and continue"
      fill_in "partner-vehicle-details-form-vehicle-value-field", with: 5_000
      select_boolean_value("partner-vehicle-details-form", :vehicle_in_regular_use, true)
      select_boolean_value("partner-vehicle-details-form", :vehicle_over_3_years_ago, true)
      select_boolean_value("partner-vehicle-details-form", :vehicle_pcp, false)
    end
  end
end
