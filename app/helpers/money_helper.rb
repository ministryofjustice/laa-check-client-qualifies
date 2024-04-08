module MoneyHelper
  include ActionView::Helpers::NumberHelper

  def format_money(value)
    number_to_currency(value, precision: 2, delimiter: ",", unit: "£")
  end

  def dependant_monthly_upper_limit
    format_money(DependantIncomeModel.dependant_monthly_upper_limit)
  end
end
