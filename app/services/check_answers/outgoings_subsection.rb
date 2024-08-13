# frozen_string_literal: true

module CheckAnswers
  class OutgoingsSubsection
    class << self
      def tables(check:, label:, attribute_prefix:)
        table = Table.new screen: label,
                          skip_change_link: false, index: nil, disputed?: nil,
                          fields: [
                            if check.eligible_for_childcare_costs?
                              OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                                      attribute: "#{attribute_prefix}childcare_payments_conditional_value".to_sym,
                                                                      model: check,
                                                                      frequency_attribute: "#{attribute_prefix}childcare_payments_frequency".to_sym,
                                                                      relevancy_attribute: "#{attribute_prefix}childcare_payments_relevant".to_sym)
                            end,
                            OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                                    attribute: "#{attribute_prefix}maintenance_payments_conditional_value".to_sym,
                                                                    model: check,
                                                                    frequency_attribute: "#{attribute_prefix}maintenance_payments_frequency".to_sym,
                                                                    relevancy_attribute: "#{attribute_prefix}maintenance_payments_relevant".to_sym),
                            OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                                    attribute: "#{attribute_prefix}legal_aid_payments_conditional_value".to_sym,
                                                                    model: check,
                                                                    frequency_attribute: "#{attribute_prefix}legal_aid_payments_frequency".to_sym,
                                                                    relevancy_attribute: "#{attribute_prefix}legal_aid_payments_relevant".to_sym),
                          ].compact
        [table]
      end
    end
  end
end
