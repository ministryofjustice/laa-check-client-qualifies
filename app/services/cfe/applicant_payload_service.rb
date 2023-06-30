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
        date_of_birth: applicant_form.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
        has_partner_opponent: false,
        receives_qualifying_benefit: applicant_form.passporting || false,
        employed: check.employed?,
        receives_asylum_support: false,
      }
    end
  end
end
