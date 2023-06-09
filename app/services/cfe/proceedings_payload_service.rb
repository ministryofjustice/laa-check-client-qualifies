module Cfe
  class ProceedingsPayloadService < BaseService
    PROCEEDING_TYPES = { "immigration" => "IM030", "asylum" => "IA031", "other" => "SE003", "domestic_abuse" => "DA001" }.freeze
    def call
      matter_type_form = MatterTypeForm.from_session(@session_data)
      proceeding_types = [
        {
          ccms_code: PROCEEDING_TYPES.fetch(matter_type_form.matter_type),
          client_involvement_type: "A",
        },
      ]

      payload[:proceeding_types] = proceeding_types
    end
  end
end
