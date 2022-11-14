class SubmitRegularTransactionsService < BaseCfeService
  def self.call(cfe_estimate_id, cfe_session_data)
    new.call(cfe_estimate_id, cfe_session_data)
  end

  CFE_FREQUENCIES = {
    "every_week" => :weekly,
    "every_two_weeks" => :two_weekly,
    "every_four_weeks" => :four_weekly,
    "monthly" => :monthly,
  }.freeze

  CFE_INCOME_TRANSLATIONS = {
    friends_or_family: :friends_or_family,
    maintenance_in: :maintenance,
    property_or_lodger: :property_or_lodger,
    pension: :pension,
  }.freeze

  CFE_OUTGOINGS_TRANSLATIONS = {
    rent_or_mortgage: :housing_payments,
    child_care: :childcare_payments,
    maintenance_out: :maintenance_payments,
    legal_aid: :legal_aid_payments,
  }.freeze

  def call(cfe_estimate_id, cfe_session_data)
    outgoings_form = OutgoingsForm.from_session(cfe_session_data)
    income_form = OtherIncomeForm.from_session(cfe_session_data)

    income = build_payments(CFE_INCOME_TRANSLATIONS, income_form, :credit)

    outgoings = build_payments(CFE_OUTGOINGS_TRANSLATIONS, outgoings_form, :debit)

    regular_transactions = income + outgoings

    cfe_connection.create_regular_payments(cfe_estimate_id, regular_transactions) if regular_transactions.any?
  end

  def build_payments(cfe_translations, form, operation)
    cfe_translations.select { |_cfe_name, local_name| form.send("#{local_name}_value")&.positive? }
                    .map do |cfe_name, local_name|
      {
        operation:,
        category: cfe_name,
        frequency: CFE_FREQUENCIES[form.send("#{local_name}_frequency")],
        amount: form.send("#{local_name}_value"),
      }
    end
  end
end
