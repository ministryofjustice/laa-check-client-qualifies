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
    pairs = Flow::Handler::CLASSES.select { |_, v| v.session_keys.include?(attribute.to_s) }
    return super if pairs.none?

    # 0 or 1 of the matching form classes will be valid at any one time
    step, form_class = pairs.find { |k, _| Steps::Helper.valid_step?(session_data, k) }

    return unless step

    method_name = if form_class::PREFIX
                    attribute.to_s.gsub(%r{^#{form_class::PREFIX}}, "")
                  else
                    attribute
                  end
    form_class.from_session(session_data).send(method_name)
  end

  def respond_to_missing?(attribute, include_private = false)
    return true if Flow::Handler::CLASSES.find { |_, v| v.session_keys.include?(attribute.to_s) }

    super
  end

  # The below are convenience methods that answer commonly-asked questions about the state of the
  # current session that are not directly values contained within the session

  def controlled?
    Steps::Logic.controlled?(session_data)
  end

  def smod_applicable?
    !upper_tribunal?
  end

  def upper_tribunal?
    Steps::Logic.upper_tribunal?(session_data)
  end

  def owns_property?
    Steps::Logic.owns_property?(session_data)
  end

  def partner_owns_property?
    Steps::Logic.partner_owns_property?(session_data)
  end

  def any_smod_assets?
    return false unless smod_applicable?

    house_in_dispute ||
      vehicle_in_dispute ||
      in_dispute.present? ||
      additional_house_in_dispute ||
      vehicles&.any?(&:vehicle_in_dispute) ||
      false
  end

  def property_owned_with_mortgage?
    property_owned == "with_mortgage"
  end

  def additional_property_owned_with_mortgage?
    additional_property_owned == "with_mortgage"
  end

  def partner_additional_property_owned_with_mortgage?
    partner_additional_property_owned == "with_mortgage"
  end

  def self_employed_flag_disabled?
    !self_employed_flag_enabled?
  end

  def self_employed_flag_enabled?
    FeatureFlags.enabled?(:self_employed)
  end
end
