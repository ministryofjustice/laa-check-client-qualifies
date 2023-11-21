module Cfe
  class ApplicantPayloadService < BaseService
    def call
      payload[:applicant] = build_applicant
    end

    def build_applicant
      if relevant_form?(:asylum_support)
        asylum_support_form = instantiate_form(AsylumSupportForm)
        if asylum_support_form.asylum_support
          return {
            date_of_birth: 50.years.ago.to_date,
            has_partner_opponent: false,
            receives_qualifying_benefit: false,
            employed: false,
            receives_asylum_support: true,
          }
        end
      end

      applicant_form = instantiate_form(ApplicantForm)
      {
        date_of_birth: date_of_birth(applicant_form),
        has_partner_opponent: false,
        receives_qualifying_benefit: applicant_form.passporting || false,
        employed: check.employed?,
        receives_asylum_support: false,
      }
    end

    def date_of_birth(applicant_form)
      if relevant_form?(:client_age)
        client_age_form = instantiate_form(ClientAgeForm)
        case client_age_form.client_age
        when "under_18"
          17.years.ago.to_date
        when "over_60"
          70.years.ago.to_date
        else
          50.years.ago.to_date
        end
      else
        applicant_form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date
      end
    end
  end
end
