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
    asylum_support || false
  end

  def aggregate_partner?
    partner unless asylum_support?
  end

  def smod_assets?
    return if asylum_support?

    any_smod_assets?
  end

  def client_capital_relevant?
    Steps::Helper.valid_step?(session_data, :assets)
  end

  # def client_income_relevant?
  #   Steps::Helper.valid_step?(session_data, :other_income)
  # end

  def partner_income_relevant?
    Steps::Helper.valid_step?(session_data, :partner_other_income)
  end
end
