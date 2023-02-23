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
  select_boolean(page:, form_name: "applicant-form", field: :partner, value: partner)

  if !FeatureFlags.enabled?(:controlled) && page.text.include?("domestic abuse")
    select_radio(page:, form: "applicant-form", field: "legacy-proceeding-type", value: "se003") # non-domestic abuse case
  end
end

def fill_incomes_screen(page:, subject: :client)
  prefix = subject == :partner ? "partner-" : ""
  page.fill_in "#{prefix}other-income-form-friends-or-family-value-field", with: "0"
  select_radio(page:, form: "#{prefix}other-income-form", field: "friends-or-family-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-maintenance-value-field", with: "0"
  select_radio(page:, form: "#{prefix}other-income-form", field: "maintenance-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-property-or-lodger-value-field", with: "0"
  select_radio(page:, form: "#{prefix}other-income-form", field: "property-or-lodger-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-pension-value-field", with: "0"
  select_radio(page:, form: "#{prefix}other-income-form", field: "pension-frequency", value: "monthly")
  page.fill_in "#{prefix}other-income-form-student-finance-value-field", with: "0"
  page.fill_in "#{prefix}other-income-form-other-value-field", with: "0"
end

def fill_outgoings_form(page:, subject: :client)
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
    fill_incomes_screen(page:)
  },
  outgoings: lambda { |page:|
    fill_outgoings_form(page:)
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
  },
}.freeze

PARTNER_PASSPORTED_HANDLERS = {
  partner_details: lambda { |page:|
    select_boolean(page:, form_name: "partner-details-form", field: :over_60, value: false)
  },
}.freeze

PARTNER_INCOME_HANDLERS = {
  partner_dependants: lambda { |page:|
    select_boolean(page:, form_name: "partner-dependant-details-form", field: :child_dependants, value: false)
    select_boolean(page:, form_name: "partner-dependant-details-form", field: :adult_dependants, value: false)
  },
  partner_employment: nil,
  partner_housing_benefit: lambda { |page:|
    select_boolean(page:, form_name: "partner-housing-benefit-form", field: :housing_benefit, value: false)
  },
  partner_benefits: lambda { |page:|
    select_boolean(page:, form_name: "partner-benefits-form", field: :add_benefit, value: false)
  },
  partner_income: lambda { |page:|
    fill_incomes_screen(page:, subject: :partner)
  },
  partner_outgoings: lambda { |page:|
    fill_outgoings_form(page:, subject: :partner)
  },
}.freeze

POSSIBLY_SKIPPED = %i[vehicle partner_vehicle].freeze

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

def process_handler_group(handlers, target)
  handlers.each do |page_name, handler|
    return false if target == page_name

    next if POSSIBLY_SKIPPED.include?(page_name) && current_path.split("/").last.to_sym != page_name

    if handler.present?
      if !block_given? || !yield(page_name)
        handler.call(page:)
      end
      click_on "Save and continue"
    elsif block_given? && yield(page_name)
      click_on "Save and continue"
    end
  end
  true
end

def visit_flow_page(passporting:, target:, controlled: false, partner: false, &block)
  visit_first_page

  if FeatureFlags.enabled?(:controlled)
    return if target == :level_of_help

    if !block_given? || !yield(:level_of_help)
      select_radio(page:, form: "level-of-help-form", field: "level-of-help", value: controlled ? "controlled" : "certificated")
      click_on "Save and continue"
    end
  end

  return if target == :applicant

  if !block_given? || !yield(:applicant)
    applicant_without_passporting(page:, partner:)
    if passporting
      select_boolean(page:, form_name: "applicant-form", field: :passporting, value: true)
    end
  end
  click_on "Save and continue"

  if !passporting && !process_handler_group(INCOME_HANDLERS, target, &block)
    return
  end

  return unless process_handler_group(CAPITAL_HANDLERS, target, &block)

  if partner
    partner_group = passporting ? PARTNER_PASSPORTED_HANDLERS : PARTNER_HANDLERS
    return unless process_handler_group(partner_group, target, &block)

    if !passporting && !process_handler_group(PARTNER_INCOME_HANDLERS, target, &block)
      return
    end

    return unless process_handler_group(PARTNER_CAPITAL_HANDLERS, target, &block)
  end
end

def visit_check_answers(passporting:, partner: false, &block)
  visit_flow_page(passporting:, partner:, target: nil, &block)
end
