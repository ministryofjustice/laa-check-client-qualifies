class SubmitDependantsService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    form = DependantsForm.from_session(cfe_session_data)
    return unless form.dependants

    details_form = DependantDetailsForm.from_session(cfe_session_data)

    child_dependants = Array.new(details_form.child_dependants) do
      {
        date_of_birth: 11.years.ago.to_date,
        in_full_time_education: true,
        relationship: "child_relative",
        monthly_income: 0,
        assets_value: 0,
      }
    end

    adult_dependants = Array.new(details_form.adult_dependants) do
      {
        date_of_birth: 21.years.ago.to_date,
        in_full_time_education: false,
        relationship: "adult_relative",
        monthly_income: 0,
        assets_value: 0,
      }
    end

    all_dependants = child_dependants + adult_dependants

    cfe_connection.create_dependants(cfe_estimate_id, all_dependants) if all_dependants.any?
  end
end
