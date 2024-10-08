# frozen_string_literal: true

module CheckAnswers
  module Sections
    class Dependants < Base
      def initialize(check)
        super(check:, label: :dependants)
      end

      def subsections
        child_deps = PartnerDependantFieldPresenter.new(table_label: :dependant_details, attribute: :child_dependants, type: :boolean,
                                                        model: @check)
        child_dep_count = if @check.child_dependants
                            FieldPresenter.new(table_label: :dependant_details, attribute: :child_dependants_count,
                                               type: :number_or_text,
                                               model: @check)
                          end
        adult_deps = PartnerDependantFieldPresenter.new(table_label: :dependant_details, attribute: :adult_dependants, type: :boolean,
                                                        model: @check)
        adult_dep_count = if @check.adult_dependants
                            FieldPresenter.new(table_label: :dependant_details, attribute: :adult_dependants_count,
                                               type: :number_or_text,
                                               model: @check)
                          end

        table_data = {
          dependant_details:
            [
              child_deps,
              child_dep_count,
              adult_deps,
              adult_dep_count,
            ].compact,
          dependant_income: [
            if @check.adult_dependants || @check.child_dependants
              FieldPresenter.new(table_label: :dependant_income, attribute: :dependants_get_income, type: :boolean,
                                 model: @check)
            end,
          ].compact,
        }
        main_tables = table_data.map { |screen, fields|
          Table.new(screen:, skip_change_link: false, index: nil, disputed?: false, fields:) if fields.any?
        }.compact
        income_tables = (@check.dependant_incomes || []).map.with_index do |model, index|
          Table.new(screen: :dependant_income_details, skip_change_link: false,
                    index:, disputed?: false, fields: [
                      SubFieldPresenter.new(table_label: :dependant_income_details, attribute: :frequency, type: :frequency,
                                            model:),
                      MoneySubFieldPresenter.new(table_label: :dependant_income_details, attribute: :amount,
                                                 model:, index:, disputed: false),
                    ])
        end
        [Subsection.new(tables: main_tables + income_tables)]
      end
    end
  end
end
