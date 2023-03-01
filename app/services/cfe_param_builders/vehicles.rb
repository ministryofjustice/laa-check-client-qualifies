module CfeParamBuilders
  class Vehicles
    def self.call(form)
      primary_vehicle(form) + secondary_vehicle(form)
    end

    def self.primary_vehicle(form)
      [
        {
          value: form.vehicle_value,
          loan_amount_outstanding: form.vehicle_pcp ? form.vehicle_finance : 0,
          date_of_purchase: form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date,
          in_regular_use: form.vehicle_in_regular_use,
          subject_matter_of_dispute: form.vehicle_in_dispute,
        },
      ]
    end

    def self.secondary_vehicle(form)
      return [] unless form.additional_vehicle_owned

      [
        {
          value: form.additional_vehicle_value,
          loan_amount_outstanding: form.additional_vehicle_pcp ? form.additional_vehicle_finance : 0,
          date_of_purchase: form.additional_vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date,
          in_regular_use: form.additional_vehicle_in_regular_use,
          subject_matter_of_dispute: form.additional_vehicle_in_dispute,
        },
      ]
    end
  end
end
