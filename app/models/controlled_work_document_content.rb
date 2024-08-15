# This model presents the session data for a check in a way that enables ControlledWorkDocumentValueMappingService
# to access all the values specified by any given "mapping". These mappings specify a method in this model.

# These methods are either defined below, or in one of the Summarisable modules included below, or on the Check superclass,
# or, if they are simple session attributes, they are defined in one of the Form classes (see Check#method_missing)
class ControlledWorkDocumentContent < Check
  include IncomeSummarisable
  include OutgoingsSummarisable
  include AssetSummarisable
  include PropertySummarisable

  def from_cfe_payload(path)
    session_data.dig("api_response", *path.split("."))
  end

  def asylum_support?
    return if under_eighteen_no_means_test_required?

    asylum_support || false
  end

  def aggregate_partner?
    partner unless asylum_support?
  end

  def smod_assets?
    return if under_eighteen_no_means_test_required? || asylum_support?

    any_smod_assets?
  end

  def client_capital_relevant?
    !Steps::Logic.non_means_tested?(session_data)
  end

  def partner_capital_relevant?
    !Steps::Logic.non_means_tested?(session_data) && Steps::Logic.partner?(session_data)
  end

  def client_income_relevant?
    !Steps::Logic.non_means_tested?(session_data) && !Steps::Logic.passported?(session_data)
  end

  def partner_income_relevant?
    !Steps::Logic.non_means_tested?(session_data) && !Steps::Logic.passported?(session_data) && Steps::Logic.partner?(session_data)
  end
end
