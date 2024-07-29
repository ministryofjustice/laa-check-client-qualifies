# This model can be interrogated to return all and only _relevant_ data from the session.
# That is to say, you can call `check.gross_income`, and this will return the value
# the user has entered for the client's gross income IF the client is employed AND
# does not receive a passporting benefit AND does not receive Asylum Support.

# The methods to call are not defined explicitly, but rather are inferred using the
# `method_missing` method, in which method calls are delegated to the appropriate
# form object but only if the form is associated with a valid step in the flow.
class Check
  def initialize(session_data = {})
    @session_data = session_data
  end

  attr_reader :session_data

  def method_missing(attribute, *args, &block)
    # A given attribute could be found in one of multiple different form classes
    pairs = Flow::Handler::STEPS.select { |_, v| v[:class].session_keys.include?(attribute.to_s) }
    return super if pairs.none?

    # 0 or 1 of the matching form classes will be valid at any one time
    step, step_data = pairs.find { |k, _| Steps::Helper.valid_step?(session_data, k) }

    return unless step

    form_class = step_data[:class]
    method_name = if form_class::PREFIX
                    attribute.to_s.gsub(%r{^#{form_class::PREFIX}}, "")
                  else
                    attribute
                  end
    form_class.from_session(session_data).send(method_name)
  end

  def respond_to_missing?(attribute, include_private = false)
    return true if Flow::Handler::STEPS.find { |_, v| v[:class].session_keys.include?(attribute.to_s) }

    super
  end

  # The below are convenience methods that answer commonly-asked questions about the state of the
  # current session that are not directly values contained within the session

  def controlled?
    Steps::Logic.controlled?(session_data)
  end

  def smod_applicable?
    !immigration_or_asylum?
  end

  def immigration_or_asylum?
    Steps::Logic.immigration_or_asylum?(session_data)
  end

  def owns_property?
    Steps::Logic.owns_property?(session_data)
  end

  def any_smod_assets?
    return false unless smod_applicable?

    house_in_dispute ||
      bank_accounts&.any?(&:account_in_dispute) ||
      investments_in_dispute ||
      valuables_in_dispute ||
      additional_properties&.any?(&:house_in_dispute) ||
      vehicles&.any?(&:vehicle_in_dispute) ||
      false
  end

  def property_owned_with_mortgage?
    property_owned == "with_mortgage"
  end

  def immigration_matter?
    if controlled?
      # For controlled work, "immigration_legal_help" is treated like "asylum"
      immigration_or_asylum_type == "immigration_clr"
    else
      immigration_or_asylum_type_upper_tribunal == "immigration_upper"
    end
  end

  def partner_employed?
    Steps::Logic.partner_employed?(session_data)
  end

  def client_self_employed?
    incomes && incomes.any? { _1.income_type == "self_employment" }
  end

  def partner_self_employed?
    partner_incomes && partner_incomes.any? { _1.income_type == "self_employment" }
  end

  def eligible_for_childcare_costs?
    ChildcareEligibilityService.call(self)
  end

  def under_eighteen_no_means_test_required?
    Steps::Logic.under_eighteen_no_means_test_required?(session_data)
  end

  def not_aggregated_no_income_low_capital?
    Steps::Logic.not_aggregated_no_income_low_capital?(session_data)
  end

  def under_eighteen?
    Steps::Logic.client_under_eighteen?(session_data)
  end

  def investments_relevant?
    investments_relevant
  end

  def partner_investments_relevant?
    partner_investments_relevant
  end

  def valuables_relevant?
    valuables_relevant
  end

  def partner_valuables_relevant?
    partner_valuables_relevant
  end

  def housing_benefit_relevant?
    FeatureFlags.enabled?(:legacy_housing_benefit_without_reveals, session_data) || housing_benefit_relevant
  end
end
