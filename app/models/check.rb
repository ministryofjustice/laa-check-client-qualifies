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
    step, form_class = Flow::Handler::CLASSES.find { |_, v| v.session_keys.include?(attribute.to_s) }
    return super unless form_class
    return unless Steps::Helper.valid_step?(session_data, step)

    form_class.from_session(session_data).send(attribute.to_s.gsub(/^partner_/, ""))
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
end
