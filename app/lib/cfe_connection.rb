class CfeConnection
  CFE_HOST = Rails.configuration.check_financial_eligibility_host

  class << self
    def connection
      CfeConnection.new
    end
  end

  def create_assessment_id
    create_request = {
      submission_date: Time.zone.today,
    }
    response = cfe_connection.post("assessments", create_request)
    response.body.symbolize_keys.fetch(:assessment_id)
  end

  def create_proceeding_type(assessment_id, proceeding_type)
    proceeding_types = [
      {
        ccms_code: proceeding_type,
        client_involvement_type: "A",
      },
    ]
    create_record(assessment_id, "proceeding_types", proceeding_types:)
  end

  def create_applicant(assessment_id, date_of_birth:, receives_qualifying_benefit:)
    applicant = {
      date_of_birth:,
      has_partner_opponent: false,
      receives_qualifying_benefit:,
    }
    create_record(assessment_id, "applicant", applicant:)
  end

  def create_dependants(assessment_id, dependants)
    create_record(assessment_id, "dependants", dependants:)
  end

  def create_irregular_income(assessment_id, payments:)
    create_record(assessment_id, "irregular_incomes", payments:)
  end

  def create_employment(assessment_id, employment_income)
    create_record(assessment_id, "employments", employment_income:)
  end

  CFE_OUTGOINGS_FREQUENCIES = {
    "every_week" => :weekly,
    "every_two_weeks" => :two_weekly,
    "every_four_weeks" => :four_weekly,
    "monthly" => :monthly,
  }.freeze

  def create_regular_payments(assessment_id, income_form, outgoings_form)
    income = {
      friends_or_family: (income_form.friends_or_family if income_form.monthly_incomes.include?("friends_or_family")),
      maintenance_in: (income_form.maintenance if income_form.monthly_incomes.include?("maintenance")),
      property_or_lodger: (income_form.property_or_lodger if income_form.monthly_incomes.include?("property_or_lodger")),
      pension: (income_form.pension if income_form.monthly_incomes.include?("pension")),
    }.select { |_k, v| v.present? }.map do |category, amount|
      { operation: :credit,
        category:,
        frequency: :monthly,
        amount: }
    end

    outgoings = {
      rent_or_mortgage: :housing_payments,
      child_care: :childcare_payments,
      maintenance_out: :maintenance_payments,
      legal_aid: :legal_aid_payments,
    }.select { |_k, type| outgoings_form&.send("#{type}_value")&.positive? }
    .map do |category, type|
      { operation: :debit,
        category:,
        frequency: CFE_OUTGOINGS_FREQUENCIES[outgoings_form.send("#{type}_frequency")],
        amount: outgoings_form.send("#{type}_value") }
    end

    regular_transactions = income + outgoings

    create_record(assessment_id, "regular_transactions", regular_transactions:) if regular_transactions.any?
  end

  def create_benefits(assessment_id, state_benefits)
    create_record(assessment_id, "state_benefits", state_benefits:)
  end

  def create_properties(assessment_id, main_property, second_property)
    main_home = main_property ||
      {
        value: 0,
        outstanding_mortgage: 0,
        percentage_owned: 0,
      }
    properties = { main_home: main_home.merge(shared_with_housing_assoc: false) }
    properties[:additional_properties] = [second_property.merge(shared_with_housing_assoc: false)] if second_property
    create_record(assessment_id, "properties", properties:)
  end

  def create_capitals(assessment_id, liquid_assets, illiquid_assets)
    # descriptions are mandatory in CFE
    bank_accounts = liquid_assets.map do |amount|
      {
        value: amount,
        description: "Liquid Asset",
      }
    end
    non_liquid_capital = illiquid_assets.map do |amount|
      {
        value: amount,
        description: "Non Liquid Asset",
      }
    end
    create_record(assessment_id, "capitals", bank_accounts:, non_liquid_capital:)
  end

  def create_vehicle(assessment_id, value:, loan_amount_outstanding:, date_of_purchase:, in_regular_use:)
    vehicles = [
      {
        value:,
        loan_amount_outstanding:,
        date_of_purchase:,
        in_regular_use:,
      },
    ]
    create_record(assessment_id, "vehicles", vehicles:)
  end

  def api_result(assessment_id)
    url = "/assessments/#{assessment_id}"
    response = cfe_connection.get url
    validate_api_response(response, url)
    CalculationResult.new(response.body.deep_symbolize_keys)
  end

private

  def create_record(assessment_id, record_type, record_data)
    url = "/assessments/#{assessment_id}/#{record_type}"
    response = cfe_connection.post url, record_data
    validate_api_response(response, url)
  end

  def validate_api_response(response, url)
    return if response.success?

    raise "Call to CFE url #{url} returned status #{response.status} and message:\n#{response.body}"
  end

  def cfe_connection
    @cfe_connection ||= Faraday.new(url: CFE_HOST, headers: { "Accept" => "application/json;version=5" }) do |faraday|
      faraday.request :json
      faraday.response :json
    end
  end
end
