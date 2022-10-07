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
    response.body.symbolize_keys.fetch(:assessment_id).tap do |assessment_id|
      proceeding_types = {
        proceeding_types: [
          {
            ccms_code: "DA001",
            client_involvement_type: "A",
          },
          {
            ccms_code: "SE013",
            client_involvement_type: "I",
          },
        ],
      }

      create_record(assessment_id, "proceeding_types", proceeding_types)
    end
  end

  def create_applicant(assessment_id, date_of_birth:, receives_qualifying_benefit:)
    applicant = {
      date_of_birth:,
      has_partner_opponent: false,
      receives_qualifying_benefit:,
    }
    create_record(assessment_id, "applicant", applicant:)
  end

  def create_dependants(assessment_id, count)
    dependants = (1..count).map do
      {
        date_of_birth: 11.years.ago.to_date,
        in_full_time_education: true,
        relationship: "child_relative",
        monthly_income: 0,
        assets_value: 0,
      }
    end
    create_record(assessment_id, "dependants", dependants:)
  end

  def create_student_loan(assessment_id, amount)
    if amount.present?
      payments = [
        {
          "income_type": "student_loan",
          "frequency": "annual",
          "amount": amount,
        },
      ]
      create_record(assessment_id, "irregular_incomes", payments:)
    end
  end

  def create_regular_payments(assessment_id, income_form, outgoings_form)
    # TODO: CFE does not currently support 'other' income, and errors if we try to send it other income,
    # so for the time being we do _not_ tell CFE about other income.
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
      rent_or_mortgage: outgoings_form&.housing_payments,
    }.select { |_k, v| v.present? }.map do |category, amount|
      { operation: :debit,
        category:,
        frequency: :monthly,
        amount: }
    end

    regular_transactions = income + outgoings

    create_record(assessment_id, "regular_transactions", regular_transactions:) if regular_transactions.any?
  end

  def create_properties(assessment_id, main_home, second_property)
    properties = { main_home: main_home.merge(shared_with_housing_assoc: false) }
    properties[:additional_properties] = [second_property.merge(shared_with_housing_assoc: false)] if second_property
    create_record(assessment_id, "properties", properties:)
  end

  def create_capitals(assessment_id, savings, investments)
    bank_accounts = savings.map do |amount|
      {
        value: amount,
        description: "Liquid Asset",
      }
    end
    non_liquid_capital = investments.map do |amount|
      {
        value: amount,
        description: "Investment",
      }
    end
    create_record(assessment_id, "capitals", bank_accounts:, non_liquid_capital:) if savings.any? || investments.any?
  end

  def api_result(assessment_id)
    response = cfe_connection.get "/assessments/#{assessment_id}"
    response.body.deep_symbolize_keys
  end

private

  def create_record(assessment_id, record_type, record_data)
    cfe_connection.post "/assessments/#{assessment_id}/#{record_type}", record_data
  end

  def cfe_connection
    @cfe_connection ||= Faraday.new(url: CFE_HOST, headers: { "Accept" => "application/json;version=5" }) do |faraday|
      faraday.request :json
      faraday.response :raise_error
      faraday.response :json
    end
  end
end
