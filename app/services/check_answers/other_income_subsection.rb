# frozen_string_literal: true

module CheckAnswers
  class OtherIncomeSubsection
    class << self
      def tables(check:, other_income_field:, attribute_prefix:)
        other_income =
          Table.new(screen: other_income_field, skip_change_link: false, index: nil, disputed?: nil,
                    fields: [
                      OptionalMoneyWithFrequencyPresenter.new(table_label: other_income_field,
                                                              attribute: "#{attribute_prefix}friends_or_family_conditional_value".to_sym,
                                                              model: check,
                                                              alt_attribute: "#{attribute_prefix}friends_or_family_frequency".to_sym,
                                                              relevancy_attribute: "#{attribute_prefix}friends_or_family_relevant".to_sym),
                      OptionalMoneyWithFrequencyPresenter.new(table_label: other_income_field,
                                                              attribute: "#{attribute_prefix}maintenance_conditional_value".to_sym,
                                                              model: check,
                                                              alt_attribute: "#{attribute_prefix}maintenance_frequency".to_sym,
                                                              relevancy_attribute: "#{attribute_prefix}maintenance_relevant".to_sym),
                      OptionalMoneyWithFrequencyPresenter.new(table_label: other_income_field,
                                                              attribute: "#{attribute_prefix}property_or_lodger_conditional_value".to_sym,
                                                              model: check,
                                                              alt_attribute: "#{attribute_prefix}property_or_lodger_frequency".to_sym,
                                                              relevancy_attribute: "#{attribute_prefix}property_or_lodger_relevant".to_sym),
                      OptionalMoneyWithFrequencyPresenter.new(table_label: other_income_field,
                                                              attribute: "#{attribute_prefix}pension_conditional_value".to_sym,
                                                              model: check,
                                                              alt_attribute: "#{attribute_prefix}pension_frequency".to_sym,
                                                              relevancy_attribute: "#{attribute_prefix}pension_relevant".to_sym),
                      OptionalMoneyPresenter.new(table_label: other_income_field,
                                                 attribute: "#{attribute_prefix}student_finance_conditional_value".to_sym,
                                                 model: check,
                                                 relevancy_attribute: "#{attribute_prefix}student_finance_relevant".to_sym),
                      OptionalMoneyPresenter.new(table_label: other_income_field,
                                                 attribute: "#{attribute_prefix}other_conditional_value".to_sym,
                                                 model: check,
                                                 relevancy_attribute: "#{attribute_prefix}other_relevant".to_sym),
                    ])
        [other_income]
      end
    end
  end
end
