module Cfe
  class ApplicantPayloadService
    class << self
      def call(session_data, payload, completed_steps)
        payload[:applicant] = build_applicant completed_steps, session_data
      end

      def build_applicant(completed_steps, session_data)
        check = Check.new session_data
        ret = { date_of_birth: date_of_birth(session_data) }
        ret[:receives_qualifying_benefit] = check.passporting if BaseService.completed_form?(completed_steps, :applicant)
        ret[:receives_asylum_support] = check.asylum_support if BaseService.completed_form?(completed_steps, :asylum_support)
        ret
      end

      def date_of_birth(session_data)
        client_age_form = BaseService.instantiate_form(session_data, ClientAgeForm)
        case client_age_form.client_age
        when ClientAgeForm::UNDER_18
          17.years.ago.to_date
        when ClientAgeForm::OVER_60
          70.years.ago.to_date
        else
          50.years.ago.to_date
        end
      end
    end
  end
end
