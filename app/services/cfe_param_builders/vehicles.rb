module CfeParamBuilders
  class Vehicles
    def self.call(models, smod_applicable: false)
      models.map do |model|
        {
          value: model.vehicle_value,
          loan_amount_outstanding: model.vehicle_pcp ? model.vehicle_finance : 0,
          date_of_purchase: model.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date,
          in_regular_use: model.vehicle_in_regular_use,
          subject_matter_of_dispute: (model.vehicle_in_dispute && smod_applicable) || false,
        }
      end
    end
  end
end
