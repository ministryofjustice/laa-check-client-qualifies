module Cfe
  class ProceedingsPayloadService < BaseService
    def call
      matter_type_form = MatterTypeForm.from_session(@session_data)
      proceeding_types = [
        {
          ccms_code: matter_type_form.proceeding_type,
          client_involvement_type: "A",
        },
      ]

      payload[:proceeding_types] = proceeding_types
    end
  end
end
