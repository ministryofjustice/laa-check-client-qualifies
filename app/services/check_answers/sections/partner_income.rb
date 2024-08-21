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

        [
          subsection_for([partner_details]),
          subsection_for(EmploymentSubsection.tables(check: @check,
                                                     status_field_name: :partner_employment_status,
                                                     incomes: @check.partner_incomes,
                                                     income_field_name: :partner_income)),
          subsection_for(BenefitsSubsection.tables(check: @check,
                                                   status_field_name: :partner_benefits,
                                                   status_attribute_name: :partner_receives_benefits,
                                                   benefits: @check.partner_benefits,
                                                   benefits_field_name: :partner_benefit_details)),
          subsection_for(OtherIncomeSubsection.tables(check: @check,
                                                      other_income_field: :partner_other_income,
                                                      attribute_prefix: "partner_")),
        ].compact
      end

    private

      def subsection_for(possible_tables)
        tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
        Subsection.new(tables:) if tables.any?
      end
    end
  end
end
