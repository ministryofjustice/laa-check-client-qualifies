class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimates_path SecureRandom.uuid
  end

  def create
    cfe_estimate_id = cfe_connection.create_assessment_id

    applicant_screen_create cfe_estimate_id, Flow::ApplicantHandler.model(cfe_session_data)

    # dont call below if employment question is no
    save_employment_data cfe_estimate_id, Flow::EmploymentHandler.model(cfe_session_data)
    save_monthly_income_data cfe_estimate_id, Flow::MonthlyIncomeHandler.model(cfe_session_data)

    # dont call below if vehicle owned question is no
    save_vehicle_value_data cfe_estimate_id, Flow::Vehicle::ValueHandler.model(cfe_session_data)
    save_vehicle_finance_data cfe_estimate_id, Flow::Vehicle::FinanceHandler.model(cfe_session_data)
    save_assets_data cfe_estimate_id, Flow::AssetHandler.model(cfe_session_data)
    save_outgoings_data cfe_estimate_id, Flow::OutgoingsHandler.model(cfe_session_data)

    # dont call below if property owned question is no
    save_property_entry_data cfe_estimate_id, Flow::OutgoingsHandler.model(cfe_session_data)

    create_applicant cfe_estimate_id
    @model = cfe_connection.api_result(cfe_estimate_id)

    render :show
  end

  private

  def applicant_screen_create(estimate_id, estimate)
    cfe_connection.create_dependants(estimate_id, estimate.dependant_count) if estimate.dependants
  end

  def save_employment_data(estimate_id, form)
    puts "--------1--------"
    return unless form.gross_income.present?
    puts "--------after return should not see--------"

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

    cfe_connection.create_employment(estimate_id, employment_data)
  end


  def save_monthly_income_data(estimate_id, income_form)
    if income_form.monthly_incomes.include?("student_finance")
      cfe_connection.create_student_loan estimate_id, income_form.student_finance
    end

    cfe_connection.create_regular_payments(estimate_id, income_form, nil)
  end

  def save_vehicle_value_data (estimate_id, value_form)
    puts "--------2--------"
    return unless value_form.vehicle_value.present?
    puts "--------after return should not see--------"

    cfe_connection.create_vehicle estimate_id, date_of_purchase: Time.zone.today.to_date,
                                  value: value_form.vehicle_value,
                                  loan_amount_outstanding: 0,
                                  in_regular_use: value_form.vehicle_in_regular_use
  end

  def save_vehicle_finance_data(estimate_id, form)
    puts "--------3--------"
    value_form = Flow::Vehicle::ValueHandler.model(cfe_session_data)

    return unless value_form.vehicle_value.present?
    puts "--------after return should not see--------"

    age_form = Flow::Vehicle::AgeHandler.model(cfe_session_data)
    date_of_purchase = age_form.vehicle_over_3_years_ago ? 4.years.ago.to_date : 2.years.ago.to_date
    cfe_connection.create_vehicle estimate_id,
                                  date_of_purchase:,
                                  value: value_form.vehicle_value,
                                  loan_amount_outstanding: form.vehicle_finance.presence,
                                  in_regular_use: value_form.vehicle_in_regular_use
  end

  def save_assets_data(estimate_id, form)
    savings = [form.savings].compact
    investments = [form.investments].compact
    cfe_connection.create_capitals estimate_id, savings, investments

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
      cfe_connection.create_properties(estimate_id, main_home, second_property)
    end
  end

  def save_outgoings_data(estimate_id, outgoings_form)
    income_form = Flow::MonthlyIncomeHandler.model(cfe_session_data)

    cfe_connection.create_regular_payments(estimate_id, income_form, outgoings_form)
  end

  def save_property_entry_data(estimate_id, _model)
    puts "--------4--------"
    property_model = Flow::PropertyEntryHandler.model(cfe_session_data)

    return unless property_model.house_value.present?
    puts "--------after return should not see--------"
    main_home = {
      value: property_model.house_value,
      outstanding_mortgage: (property_model.mortgage.presence if cfe_session_data["property_owned"] == "with_mortgage") || 0,
      percentage_owned: property_model.percentage_owned
    }
    cfe_connection.create_properties(estimate_id, main_home, nil)
  end

  def create_applicant cfe_estimate_id
    estimate = Flow::ApplicantHandler.model(cfe_session_data)
    cfe_connection.create_applicant cfe_estimate_id,
                                    date_of_birth: estimate.over_60 ? 70.years.ago.to_date : 50.years.ago.to_date,
                                    receives_qualifying_benefit: estimate.passporting
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

  def cfe_session_data
    session_data params[:cfe_id]
  end
end
