class CfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  def call(cfe_estimate_id, cfe_session_data)
    save_dependants_data cfe_estimate_id, Flow::ApplicantHandler.model(cfe_session_data)
    save_employment_data cfe_estimate_id, Flow::EmploymentHandler.model(cfe_session_data)
    save_monthly_income_data cfe_estimate_id, Flow::MonthlyIncomeHandler.model(cfe_session_data)
    save_vehicle_value_data cfe_estimate_id, Flow::Vehicle::ValueHandler.model(cfe_session_data)
    save_vehicle_finance_data cfe_estimate_id, cfe_session_data
    save_assets_data cfe_estimate_id, cfe_session_data
    save_outgoings_data cfe_estimate_id, cfe_session_data
    save_property_entry_data cfe_estimate_id, cfe_session_data
    create_applicant cfe_estimate_id, Flow::ApplicantHandler.model(cfe_session_data)
  end

  private

  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end

  def save_dependants_data(cfe_estimate_id, form)
    cfe_connection.create_dependants(cfe_estimate_id, form.dependant_count) if form.dependants
  end

  def save_employment_data(cfe_estimate_id, form)
    return unless form.gross_income.present?

    # CFE wants to infer frequency of payment from gaps between payments.
    # So we use our knowledge of frequency to generate three appropriately-spaced,
    # representative payments, to allow CFE to make that inference
    employment_data = [
      {
        name: "Job",
        client_id: "ID",
        payments: Array.new(3) do |index|
          {
            gross:(form.gross_income * multiplier(form)).round(2),
            tax: (-1 * form.income_tax * multiplier(form)).round(2),
            national_insurance: (-1 * form.national_insurance * multiplier(form)).round(2),
            client_id: "id-#{index}",
            date: Date.current - period(form, index),
            benefits_in_kind: 0,
            net_employment_income: ((form.gross_income - form.income_tax - form.national_insurance) * multiplier(form)).round(2),
          }
        end,
      },
    ]

    cfe_connection.create_employment(cfe_estimate_id, employment_data)
  end


  def save_monthly_income_data(cfe_estimate_id, form)
    if form.monthly_incomes.include?("student_finance")
      cfe_connection.create_student_loan cfe_estimate_id, form.student_finance
    end

    cfe_connection.create_regular_payments(cfe_estimate_id, form, nil)
  end

  def save_vehicle_value_data (cfe_estimate_id, form)
    return unless form.vehicle_value.present?

    cfe_connection.create_vehicle cfe_estimate_id, date_of_purchase: Time.zone.today.to_date,
                                  value: form.vehicle_value,
                                  loan_amount_outstanding: 0,
                                  in_regular_use: form.vehicle_in_regular_use
  end

  def save_vehicle_finance_data(cfe_estimate_id, cfe_session_data)
    finance_form = Flow::Vehicle::FinanceHandler.model(cfe_session_data)
    return unless finance_form.vehicle_pcp.present?

    value_form = Flow::Vehicle::ValueHandler.model(cfe_session_data)
    age_form = Flow::Vehicle::AgeHandler.model(cfe_session_data)
    date_of_purchase = age_form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date
    cfe_connection.create_vehicle cfe_estimate_id,
                                  date_of_purchase:,
                                  value: value_form.vehicle_value,
                                  loan_amount_outstanding: finance_form.vehicle_pcp ? finance_form.vehicle_finance.presence : 0,
                                  in_regular_use: value_form.vehicle_in_regular_use
  end

  def save_assets_data(cfe_estimate_id, cfe_session_data)
    form = Flow::AssetHandler.model(cfe_session_data)
    savings = [form.savings].compact
    investments = [form.investments].compact
    cfe_connection.create_capitals cfe_estimate_id, savings, investments

    if form.assets.include?("property")
      property_entry_form = Flow::PropertyEntryHandler.model(cfe_session_data)
      main_home = {
        value: property_entry_form.house_value,
        outstanding_mortgage: property_entry_form.mortgage,
        percentage_owned: property_entry_form.percentage_owned,
      }
      second_property = {
        value: form.property_value,
        outstanding_mortgage: form.property_mortgage,
        percentage_owned: form.property_percentage_owned,
      }
      cfe_connection.create_properties(cfe_estimate_id, main_home, second_property)
    end
  end

  def save_outgoings_data(cfe_estimate_id, cfe_session_data)
    form = Flow::OutgoingsHandler.model(cfe_session_data)
    income_form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    cfe_connection.create_regular_payments(cfe_estimate_id, income_form, form)
  end

  def save_property_entry_data(cfe_estimate_id, cfe_session_data)
    model = Flow::PropertyEntryHandler.model(cfe_session_data)
    return unless model.house_value.present?

    main_home = {
      value: model.house_value,
      outstanding_mortgage: (model.mortgage.presence if cfe_session_data["property_owned"] == "with_mortgage") || 0,
      percentage_owned: model.percentage_owned
    }
    cfe_connection.create_properties(cfe_estimate_id, main_home, nil)
  end

  def create_applicant(cfe_estimate_id, model)
    cfe_connection.create_applicant cfe_estimate_id,
                                    date_of_birth: model.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                    receives_qualifying_benefit: model.passporting
  end

  # CFE doesn't understand about annual salary or 'total income in the last 3 months',
  # so for both those use cases we must convert the figures we have into what they would
  # be if they were paid as regular monthly income
  def multiplier(form)
    case form.frequency
    when "annually"
      1.0 / 12
    when "total"
      1.0 / 3
    else
      1
    end
  end

  def period(form, index)
    case form.frequency
    when "annually", "total", "monthly"
      index.months
    when "week"
      index.weeks
    when "two_weeks"
      (index * 2).weeks
    when "four_weeks"
      (index * 4).weeks
    end
  end
end