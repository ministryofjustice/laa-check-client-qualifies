module MortgageOrLoanPaymentHelper
  def outgoings_links(level_of_help)
    {
      t("estimate_flow.mortgage_or_loan_payment.guidance_on_housing_costs.#{level_of_help}.text") =>
        t("estimate_flow.mortgage_or_loan_payment.guidance_on_housing_costs.#{level_of_help}.link"),
    }
  end
end
