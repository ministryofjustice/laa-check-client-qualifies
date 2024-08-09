# frozen_string_literal: true

module CheckAnswers
  class OutgoingsSubsection
    class << self
      def tables(check:, label:, attribute_prefix:)
        child_care = if check.eligible_for_childcare_costs?
                       OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                               attribute: "#{attribute_prefix}childcare_payments_conditional_value".to_sym,
                                                               model: check,
                                                               frequency_attribute: "#{attribute_prefix}childcare_payments_frequency".to_sym,
                                                               relevancy_attribute: "#{attribute_prefix}childcare_payments_relevant".to_sym)
                     end
        maint = OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                        attribute: "#{attribute_prefix}maintenance_payments_conditional_value".to_sym,
                                                        model: check,
                                                        frequency_attribute: "#{attribute_prefix}maintenance_payments_frequency".to_sym,
                                                        relevancy_attribute: "#{attribute_prefix}maintenance_payments_relevant".to_sym)
        legal_aid = OptionalMoneyWithFrequencyPresenter.new(table_label: label,
                                                            attribute: "#{attribute_prefix}legal_aid_payments_conditional_value".to_sym,
                                                            model: check,
                                                            frequency_attribute: "#{attribute_prefix}legal_aid_payments_frequency".to_sym,
                                                            relevancy_attribute: "#{attribute_prefix}legal_aid_payments_relevant".to_sym)

        table = Table.new screen: label,
                          skip_change_link: false, index: nil, disputed?: nil,
                          fields: [
                            child_care, maint, legal_aid
                          ].compact
        [table]
      end
    end
  end
end
