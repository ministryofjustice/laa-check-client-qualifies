# frozen_string_literal: true

module CheckAnswers
  class EmploymentSubsection
    class << self
      def tables(check:, status_field_name:, incomes:, income_field_name:)
        employment_status = Table.new(screen: status_field_name, index: nil,
                                      disputed?: false, skip_change_link: false, fields: [
                                        FieldPresenter.new(table_label: status_field_name, attribute: status_field_name, type: :select, model: check),
                                      ])

        emp_add = (incomes || []).map.with_index do |model, index|
          Table.new(screen: income_field_name, index:,
                    disputed?: false, skip_change_link: false,
                    fields: [
                      SubFieldPresenter.new(table_label: income_field_name, attribute: :income_type, type: :select, model:, index:),
                      SubFieldPresenter.new(table_label: income_field_name, attribute: :income_frequency, type: :frequency, model:, index:),
                      SubFieldPresenter.new(table_label: income_field_name, attribute: :gross_income, type: :money, model:, index:),
                      SubFieldPresenter.new(table_label: income_field_name, attribute: :income_tax, type: :money, model:, index:),
                      SubFieldPresenter.new(table_label: income_field_name, attribute: :national_insurance, type: :money, model:, index:),
                    ])
        end
        [employment_status] + emp_add
      end
    end
  end
end
