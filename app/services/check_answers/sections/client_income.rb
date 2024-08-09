# frozen_string_literal: true

module CheckAnswers
  module Sections
    class ClientIncome < Base
      def initialize(check)
        super(check:, label: :client_income)
      end

      def subsections
        [
          Subsection.new(tables: EmploymentSubsection.tables(check: @check,
                                                             status_field_name: :employment_status,
                                                             incomes: @check.incomes,
                                                             income_field_name: :income)),
          Subsection.new(tables: BenefitsSubsection.tables(check: @check,
                                                           status_field_name: :benefits,
                                                           status_attribute_name: :receives_benefits,
                                                           benefits: @check.benefits,
                                                           benefits_field_name: :benefit_details)),
          Subsection.new(tables: OtherIncomeSubsection.tables(check: @check,
                                                              other_income_field: :other_income,
                                                              attribute_prefix: "")),
        ].compact
      end
    end
  end
end
