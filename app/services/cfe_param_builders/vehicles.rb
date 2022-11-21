module CfeParamBuilders
  class Vehicles
    def self.call(form, in_dispute: false)
      [
        {
          value: form.vehicle_value,
          loan_amount_outstanding: form.vehicle_pcp ? form.vehicle_finance : 0,
          date_of_purchase: form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date,
          in_regular_use: form.vehicle_in_regular_use,
          subject_matter_of_dispute: in_dispute,
        },
      ]
    end
  end
end
