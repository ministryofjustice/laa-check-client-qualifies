module Cfe
  class SubmitProceedingsService < BaseService
    def call(cfe_assessment_id)
      matter_type_form = MatterTypeForm.from_session(@session_data)
      proceeding_types = [
        {
          ccms_code: matter_type_form.proceeding_type,
          client_involvement_type: "A",
        },
      ]

      cfe_connection.create_proceeding_types(cfe_assessment_id, proceeding_types)
    end
  end
end
