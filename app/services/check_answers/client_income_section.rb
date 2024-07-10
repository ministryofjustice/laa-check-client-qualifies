# frozen_string_literal: true

module CheckAnswers
  class ClientIncomeSection
    def initialize(check)
      @check = check
    end

    def label
      :client_income
    end

    def subsections
      employment_table =
        Table.new(screen: :employment_status, skip_change_link: false, index: nil, disputed?: nil, fields: [
          FieldPresenter.new(table_label: :employment_status, attribute: :employment_status, type: :select, model: @check),
        ])

      add_another_tables = (@check.incomes || []).map.with_index do |model, index|
        Table.new(screen: :income, skip_change_link: false, index:, disputed?: nil, fields: [
          SubFieldPresenter.new(table_label: :income, attribute: :income_type, type: :select, model:, index:),
          SubFieldPresenter.new(table_label: :income, attribute: :income_frequency, type: :frequency, model:, index:),
          SubFieldPresenter.new(table_label: :income, attribute: :gross_income, type: :money, model:, index:),
          SubFieldPresenter.new(table_label: :income, attribute: :income_tax, type: :money, model:, index:),
          SubFieldPresenter.new(table_label: :income, attribute: :national_insurance, type: :money, model:, index:),
        ])
      end

      benefits =
        Table.new(screen: :benefits, skip_change_link: false, index: nil, disputed?: nil,
                  fields: [
                    FieldPresenter.new(table_label: :benefits, attribute: :receives_benefits, type: :boolean, model: @check),
                  ])

      benefits_add = (@check.benefits || []).map.with_index do |model, index|
        Table.new(screen: :benefit_details, skip_change_link: false, index:, disputed?: nil,
                  fields: [
                    SubFieldPresenter.new(table_label: :benefit_details, attribute: :benefit_type, type: :number_or_text, model:, index:),
                    SubFieldPresenter.new(table_label: :benefit_details, attribute: :benefit_amount, type: :money, model:, index:),
                    SubFieldPresenter.new(table_label: :benefit_details, attribute: :benefit_frequency, type: :frequency, model:, index:),
                  ])
      end

      other_income = [
        Table.new(screen: :other_income, skip_change_link: false, index: nil, disputed?: nil,
                  fields: [
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :other_income, attribute: :friends_or_family_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :friends_or_family_frequency,
                                                           second_alt_attribute: :friends_or_family_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :other_income, attribute: :maintenance_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :maintenance_frequency,
                                                           second_alt_attribute: :maintenance_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :other_income, attribute: :property_or_lodger_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :property_or_lodger_frequency,
                                                           second_alt_attribute: :property_or_lodger_relevant),
                    BooleanMoneyWithFrequencyPresenter.new(table_label: :other_income, attribute: :pension_conditional_value,
                                                           model: @check,
                                                           alt_attribute: :pension_frequency,
                                                           second_alt_attribute: :pension_relevant),
                    BooleanMoneyPresenter.new(table_label: :other_income, attribute: :student_finance_conditional_value,
                                              model: @check,
                                              alt_attribute: :student_finance_relevant),
                    BooleanMoneyPresenter.new(table_label: :other_income, attribute: :other_conditional_value,
                                              model: @check,
                                              alt_attribute: :other_relevant),
                  ]),
      ]
      [
        subsection_for([employment_table] + add_another_tables),
        subsection_for([benefits] + benefits_add),
        subsection_for(other_income),
      ].compact
    end

  private

    def subsection_for(possible_tables)
      tables = possible_tables.select { Steps::Helper.relevant_steps(@check.session_data).include?(_1.screen) }
      Subsection.new(tables:) if tables.any?
    end
  end
end
