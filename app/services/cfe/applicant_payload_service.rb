module Cfe
  class ApplicantPayloadService < BaseService
    def call
      payload[:applicant] = build_applicant
    end

    def build_applicant
      ret = { date_of_birth: }
      ret[:receives_qualifying_benefit] = check.passporting unless check.non_means_tested?
      ret[:receives_asylum_support] = check.asylum_support if check.immigration_or_asylum?
      ret
    end

    def date_of_birth
      client_age_form = instantiate_form(ClientAgeForm)
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
