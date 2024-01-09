class JourneyLoggerService
  class << self
    def call(assessment_id, calculation_result, check, cookies)
      return if cookies[CookiesController::NO_ANALYTICS_MODE]

      attributes = build_attributes(calculation_result, check)
      CompletedUserJourney.transaction do
        if (journey = CompletedUserJourney.find_by(assessment_id:))
          journey.update!(attributes)
        else
          CompletedUserJourney.create!(attributes.merge(assessment_id:))
        end
      end
    rescue StandardError => e
      ErrorService.call(e)
    end

    def build_attributes(calculation_result, check)
      {
        completed: Date.current,
        certificated: !check.controlled?,
        partner: check.partner || false,
        client_age: check.client_age,
        person_over_60: check.client_age == ClientAgeForm::OVER_60 || check.partner_over_60 || false,
        passported: check.passporting || false,
        main_dwelling_owned: check.owns_property? || false,
        vehicle_owned: check.vehicle_owned || false,
        smod_assets: check.any_smod_assets?,
        outcome: calculation_result.decision,
        capital_contribution: calculation_result.raw_capital_contribution&.positive? || false,
        income_contribution: calculation_result.raw_income_contribution&.positive? || false,
        asylum_support: check.asylum_support || false,
        matter_type: matter_type(check),
        session: check.session_data,
      }
    end

    def matter_type(check)
      if !check.controlled? && !check.domestic_abuse_applicant
        if check.immigration_or_asylum_type_upper_tribunal == "immigration_upper"
          "immigration"
        elsif check.immigration_or_asylum_type_upper_tribunal == "asylum_upper"
          "asylum"
        else
          "other"
        end
      elsif check.domestic_abuse_applicant
        "domestic_abuse"
      elsif !check.immigration_or_asylum
        "other"
      else
        check.immigration_or_asylum_type
      end
    end
  end
end
