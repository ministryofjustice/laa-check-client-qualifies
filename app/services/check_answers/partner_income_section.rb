# frozen_string_literal: true

module CheckAnswers
  class PartnerIncomeSection
    def initialize(check)
      @check = check
    end

    def label
      :partner_income
    end

    # other than partner_details, this is almost a straight copy of client_income_section with some field names changed.
    # this isn't very DRY - can't imagine any scenario where the partner and client finances would be that different.
    def subsections
      partner_details = Table.new(screen: :partner_details, index: nil, disputed?: false, skip_change_link: false, fields: [
        FieldPresenter.new(table_label: :partner_details, attribute: :partner_over_60, type: :boolean, model: @check),
      ])

      employment_status = Table.new(screen: :partner_employment_status, index: nil,
                                    disputed?: false, skip_change_link: false, fields: [
                                      FieldPresenter.new(table_label: :partner_employment_status, attribute: :partner_employment_status, type: :select, model: @check),
                                    ])

      emp_add = (@check.partner_incomes || []).map.with_index do |model, index|
        Table.new(screen: :partner_income, index:,
                  disputed?: false, skip_change_link: false,
                  fields: [
                    SubFieldPresenter.new(table_label: :partner_income, attribute: :income_type, type: :select, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_income, attribute: :income_frequency, type: :frequency, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_income, attribute: :gross_income, type: :money, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_income, attribute: :income_tax, type: :money, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_income, attribute: :national_insurance, type: :money, model:, index:),
                  ])
      end

      benefits =
        Table.new(screen: :partner_benefits, skip_change_link: false, index: nil, disputed?: nil,
                  fields: [
                    FieldPresenter.new(table_label: :partner_benefits, attribute: :partner_receives_benefits, type: :boolean, model: @check),
                  ])

      benefits_add = (@check.partner_benefits || []).map.with_index do |model, index|
        Table.new(screen: :partner_benefit_details, skip_change_link: false, index:, disputed?: nil,
                  fields: [
                    SubFieldPresenter.new(table_label: :partner_benefit_details, attribute: :benefit_type, type: :number_or_text, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_benefit_details, attribute: :benefit_amount, type: :money, model:, index:),
                    SubFieldPresenter.new(table_label: :partner_benefit_details, attribute: :benefit_frequency, type: :frequency, model:, index:),
                  ])
      end

      other_income =
        Table.new(screen: :partner_other_income, skip_change_link: false, index: nil, disputed?: nil,
                  fields: [
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :partner_other_income,
                                                           attribute: :partner_friends_or_family_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :partner_friends_or_family_frequency,
                                                           second_alt_attribute: :partner_friends_or_family_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :partner_other_income,
                                                           attribute: :partner_maintenance_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :partner_maintenance_frequency,
                                                           second_alt_attribute: :partner_maintenance_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :partner_other_income,
                                                           attribute: :partner_property_or_lodger_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :partner_property_or_lodger_frequency,
                                                           second_alt_attribute: :partner_property_or_lodger_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :partner_other_income,
                                                           attribute: :partner_pension_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :partner_pension_frequency,
                                                           second_alt_attribute: :partner_pension_relevant),
                    BooleanMoneyPresenter.new(table_label: :partner_other_income,
                                              attribute: :partner_student_finance_conditional_value,
                                              model: @check,
                                              alt_attribute: :partner_student_finance_relevant),
                    BooleanMoneyPresenter.new(table_label: :partner_other_income,
                                              attribute: :partner_other_conditional_value,
                                              model: @check,
                                              alt_attribute: :partner_other_relevant),
                  ])

      [
        subsection_for([partner_details]),
        subsection_for([employment_status] + emp_add),
        subsection_for([benefits] + benefits_add),
        subsection_for([other_income]),
      ].compact
    end

  private

    def subsection_for(possible_tables)
      tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
      Subsection.new(tables:) if tables.any?
    end
  end
end
