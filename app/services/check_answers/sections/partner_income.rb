# frozen_string_literal: true

module CheckAnswers
  module Sections
    class PartnerIncome < Base
      def initialize(check)
        super(check:, label: :partner_income)
      end

      def subsections
        partner_details = Table.new(screen: :partner_details, index: nil, disputed?: false, skip_change_link: false, fields: [
          FieldPresenter.new(table_label: :partner_details, attribute: :partner_over_60, type: :boolean, model: @check),
        ])

        if @check.skip_income_questions?
          [
            Subsection.new(tables: [partner_details]),
          ]
        else
          [
            Subsection.new(tables: [partner_details]),

            Subsection.new(tables: EmploymentSubsection.tables(check: @check,
                                                               status_field_name: :partner_employment_status,
                                                               incomes: @check.partner_incomes,
                                                               income_field_name: :partner_income)),
            Subsection.new(tables: BenefitsSubsection.tables(check: @check,
                                                             status_field_name: :partner_benefits,
                                                             status_attribute_name: :partner_receives_benefits,
                                                             benefits: @check.partner_benefits,
                                                             benefits_field_name: :partner_benefit_details)),
            Subsection.new(tables: OtherIncomeSubsection.tables(check: @check,
                                                                other_income_field: :partner_other_income,
                                                                attribute_prefix: "partner_")),
          ]
        end
      end
    end
  end
end
