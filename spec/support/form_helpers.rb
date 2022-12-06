def select_applicant_boolean(field, value)
  select_boolean_value("applicant-form", field, value)
end

def select_radio_value(form, field, value)
  select_radio(page:, form:, field:, value:)
end

def fill_in_applicant_screen_with_passporting_benefits(partner: true)
  fill_in_applicant_screen_without_passporting_benefits(partner:)
  select_applicant_boolean(:passporting, true)
end

def fill_in_applicant_screen_without_passporting_benefits(partner: true)
  applicant_without_passporting(page:, partner:)
end

def skip_dependants_form
  select_boolean_value("dependant-details-form", :child_dependants, false)
  select_boolean_value("dependant-details-form", :adult_dependants, false)
  click_on "Save and continue"
end

def skip_partner_dependants_form
  select_boolean_value("partner-dependant-details-form", :child_dependants, false)
  select_boolean_value("partner-dependant-details-form", :adult_dependants, false)
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

def visit_applicant_page
  visit new_estimate_path
  click_on "Reject additional cookies"
end

def fill_employment_form(prefix: "")
  fill_in "#{prefix}employment-form-gross-income-field", with: 1000
  fill_in "#employment-form-income-tax-field", with: 100
  fill_in "employment-form-national-insurance-field", with: 50
  select_radio_value("employment-form", "frequency", "total")
end

def fill_partner_employment_form
  fill_employment_form(prefix: "partner-")
end

def visit_applicant_page_with_partner
  visit_applicant_page
  fill_in_applicant_screen_without_passporting_benefits
  click_on "Save and continue"
end

def fill_outgoings_form(subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  fill_in "#{prefix}outgoings-form-housing-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-childcare-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-legal-aid-payments-value-field", with: "0"
  fill_in "#{prefix}outgoings-form-maintenance-payments-value-field", with: "0"
end

def skip_outgoings_form(subject: :client)
  fill_outgoings_form(subject:)
  click_on "Save and continue"
end

def fill_incomes_screen(subject: :client)
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
end

def complete_incomes_screen(subject: :client)
  fill_incomes_screen(subject:)
  click_on "Save and continue"
end

def skip_benefits_form
  select_boolean_value("housing-benefit-form", :housing_benefit, false)
  click_on "Save and continue"
  select_boolean_value("benefits-form", :add_benefit, false)
  click_on("Save and continue")
end

def skip_partner_benefits_form
  select_boolean_value("partner-housing-benefit-form", :housing_benefit, false)
  click_on "Save and continue"
  select_boolean_value("partner-benefits-form", :add_benefit, false)
  click_on "Save and continue"
end

def fill_assets_form(subject: :client)
  fill_in "#{subject}-assets-form-property-value-field", with: "0"
  fill_in "#{subject}-assets-form-savings-field", with: "0"
  fill_in "#{subject}-assets-form-investments-field", with: "0"
  fill_in "#{subject}-assets-form-valuables-field", with: "0"
end

def skip_assets_form(subject: :client)
  fill_assets_form(subject:)
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

def travel_from_housing_benefit_to_past_client_assets
  skip_dependants_form
  select_boolean_value("housing-benefit-form", :housing_benefit, false)
  click_on("Save and continue")
  select_boolean_value("benefits-form", :add_benefit, false)
  click_on("Save and continue")
  complete_incomes_screen
  skip_outgoings_form

  select_radio_value("property-form", "property-owned", "none")
  click_on "Save and continue"
  select_boolean_value("vehicle-form", :vehicle_owned, false)
  click_on "Save and continue"
  skip_assets_form
end

def visit_check_answer_with_partner
  visit_check_answers(passporting: false, partner: true) do |step|
    case step
    when :partner_details
      select_boolean_value("partner-details-form", :over_60, false)
      select_boolean_value("partner-details-form", :employed, true)
    when :partner_employment
      fill_in "partner-employment-form-gross-income-field", with: 1000
      fill_in "partner-employment-form-income-tax-field", with: 100
      fill_in "partner-employment-form-national-insurance-field", with: 50
      select_radio_value("partner-employment-form", "frequency", "monthly")
    when :partner_benefits
      select_boolean_value("partner-benefits-form", :add_benefit, true)
      click_on "Save and continue"
      fill_in "Benefit type", with: "Child benefit"
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

def select_boolean(page:, form_name:, field:, value:)
  fieldname = field.to_s.tr("_", "-")
  if value
    page.find("label[for=#{form_name}-#{fieldname}-true-field]").click
  else
    page.find("label[for=#{form_name}-#{fieldname}-field]").click
  end
end

def select_radio(page:, form:, field:, value:)
  fieldname = field.to_s.tr("_", "-")
  if value
    fieldvalue = value.to_s.tr("_", "-")
    page.find("label[for=#{"#{form}-#{fieldname}"}-#{fieldvalue}-field]").click
  else
    page.find("label[for=#{"#{form}-#{fieldname}"}-field]").click
  end
end

def applicant_without_passporting(page:, partner:)
  %i[over_60 employed passporting].each do |attribute|
    select_boolean(page:, form_name: "applicant-form", field: attribute, value: false)
  end
  select_radio(page:, form: "applicant-form", field: "proceeding-type", value: "se003") # non-domestic abuse case

  if Flipper.enabled?(:partner)
    select_boolean(page:, form_name: "applicant-form", field: :partner, value: partner)
  end
end

def incomes_screen(page:, subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  page.fill_in "#{prefix}other-income-form-friends-or-family-value-field", with: "100"
  select_radio(page:, form: "#{prefix}other-income-form", field: "friends-or-family-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-maintenance-value-field", with: "200"
  select_radio(page:, form: "#{prefix}other-income-form", field: "maintenance-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-property-or-lodger-value-field", with: "300"
  select_radio(page:, form: "#{prefix}other-income-form", field: "property-or-lodger-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-pension-value-field", with: "400"
  select_radio(page:, form: "#{prefix}other-income-form", field: "pension-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-student-finance-value-field", with: "0"
  page.fill_in "#{prefix}other-income-form-other-value-field", with: "500"
end

def outgoings_form(page:, subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  page.fill_in "#{prefix}outgoings-form-housing-payments-value-field", with: "0"
  page.fill_in "#{prefix}outgoings-form-childcare-payments-value-field", with: "0"
  page.fill_in "#{prefix}outgoings-form-legal-aid-payments-value-field", with: "0"
  page.fill_in "#{prefix}outgoings-form-maintenance-payments-value-field", with: "0"
end

def assets_form(page:, subject: :client)
  page.fill_in "#{subject}-assets-form-property-value-field", with: "0"
  page.fill_in "#{subject}-assets-form-savings-field", with: "0"
  page.fill_in "#{subject}-assets-form-investments-field", with: "0"
  page.fill_in "#{subject}-assets-form-valuables-field", with: "0"
end

PAGE_HANDLERS = {
  applicant: lambda { |page:, passporting:, partner:|
    applicant_without_passporting(page:, partner:)
    if passporting
      select_boolean(page:, form_name: "applicant-form", field: :passporting, value: true)
    end
  },
}.freeze

INCOME_HANDLERS = {
  dependants: lambda { |page:|
    select_boolean(page:, form_name: "dependant-details-form", field: :child_dependants, value: false)
    select_boolean(page:, form_name: "dependant-details-form", field: :adult_dependants, value: false)
  },
  employment: nil,
  housing_benefit: lambda { |page:|
    select_boolean(page:, form_name: "housing-benefit-form", field: :housing_benefit, value: false)
  },
  benefits: lambda { |page:|
    select_boolean(page:, form_name: "benefits-form", field: :add_benefit, value: false)
  },
  income: lambda { |page:|
    incomes_screen(page:)
  },
  outgoings: lambda { |page:|
    outgoings_form(page:)
  },
}.freeze

CAPITAL_HANDLERS = {
  property: lambda { |page:|
    select_radio(page:, form: "property-form", field: "property-owned", value: "none")
  },
  vehicle: lambda { |page:|
    select_boolean(page:, form_name: "vehicle-form", field: :vehicle_owned, value: false)
  },
  assets: lambda { |page:|
    assets_form(page:)
  },
}.freeze

PARTNER_HANDLERS = {
  partner_details: lambda { |page:|
    select_boolean(page:, form_name: "partner-details-form", field: :over_60, value: false)
    select_boolean(page:, form_name: "partner-details-form", field: :employed, value: false)
    select_boolean(page:, form_name: "partner-details-form", field: :dependants, value: false)
  },
  partner_dependants: lambda { |page:|
    select_boolean(page:, form_name: "partner-dependant-details-form", field: :child_dependants, value: false)
    select_boolean(page:, form_name: "partner-dependant-details-form", field: :adult_dependants, value: false)
  },
}.freeze

PARTNER_INCOME_HANDLERS = {
  partner_employment: nil,
  partner_housing_benefit: lambda { |page:|
    select_boolean(page:, form_name: "partner-housing-benefit-form", field: :housing_benefit, value: false)
  },
  partner_benefits: lambda { |page:|
    select_boolean(page:, form_name: "partner-benefits-form", field: :add_benefit, value: false)
  },
  partner_income: lambda { |page:|
    incomes_screen(page:, subject: :partner)
  },
  partner_outgoings: lambda { |page:|
    outgoings_form(page:, subject: :partner)
  },
}.freeze

PARTNER_CAPITAL_HANDLERS = {
  partner_property: lambda { |page:|
    select_radio(page:, form: "partner-property-form", field: "property-owned", value: "none")
  },
  partner_vehicle: lambda { |page:|
    select_boolean(page:, form_name: "partner-vehicle-form", field: :vehicle_owned, value: false)
  },
  partner_assets: lambda { |page:|
    assets_form(page:, subject: :partner)
  },
}.freeze

def page_handler(page_name, handler)
  if handler.present?
    unless yield page_name
      handler.call(page:)
    end
    click_on "Save and continue"
  elsif yield page_name
    click_on "Save and continue"
  end
end

def visit_check_answers(passporting:, partner: false, &block)
  visit_applicant_page
  PAGE_HANDLERS.each do |page_name, handler|
    unless yield page_name
      handler.call(page:, passporting:, partner:)
    end
    click_on "Save and continue"
  end

  unless passporting
    INCOME_HANDLERS.each do |page_name, handler|
      page_handler page_name, handler, &block
    end
  end

  CAPITAL_HANDLERS.each do |page_name, handler|
    page_handler page_name, handler, &block
  end

  if partner
    PARTNER_HANDLERS.each do |page_name, handler|
      page_handler page_name, handler, &block
    end

    unless passporting
      PARTNER_INCOME_HANDLERS.each do |page_name, handler|
        page_handler page_name, handler, &block
      end
    end

    PARTNER_CAPITAL_HANDLERS.each do |page_name, handler|
      page_handler page_name, handler, &block
    end
  end
end
