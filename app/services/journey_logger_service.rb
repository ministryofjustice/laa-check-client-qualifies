class JourneyLoggerService
  class << self
    def call(assessment_id, calculation_result, estimate)
      attributes = build_attributes(calculation_result, estimate)
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

    def build_attributes(calculation_result, estimate)
      {
        certificated: !estimate.controlled?,
        partner: estimate.partner || false,
        person_over_60: estimate.over_60 || (estimate.partner && estimate.partner_over_60) || false,
        passported: estimate.passporting || false,
        main_dwelling_owned: estimate.owns_property? || estimate.partner_owns_property? || false,
        vehicle_owned: estimate.vehicle_owned || estimate.partner && estimate.partner_vehicle_owned || false,
        smod_assets: estimate.any_smod_assets? || false,
        outcome: calculation_result.decision,
        capital_contribution: calculation_result.raw_capital_contribution&.positive? || false,
        income_contribution: calculation_result.raw_income_contribution&.positive? || false,
      }
    end
  end
end
