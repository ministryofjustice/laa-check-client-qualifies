# frozen_string_literal: true

module CheckAnswers
  class BenefitsSubsection
    class << self
      def tables(check:, status_field_name:, status_attribute_name:, benefits:, benefits_field_name:)
        benefit_table =
          Table.new(screen: status_field_name, skip_change_link: false, index: nil, disputed?: nil,
                    fields: [
                      FieldPresenter.new(table_label: status_field_name, attribute: status_attribute_name, type: :boolean, model: check),
                    ])

        benefits_add = (benefits || []).map.with_index do |model, index|
          Table.new(screen: benefits_field_name, skip_change_link: false, index:, disputed?: nil,
                    fields: [
                      SubFieldPresenter.new(table_label: benefits_field_name, attribute: :benefit_type, type: :number_or_text, model:, index:),
                      SubFieldPresenter.new(table_label: benefits_field_name, attribute: :benefit_amount, type: :money, model:, index:),
                      SubFieldPresenter.new(table_label: benefits_field_name, attribute: :benefit_frequency, type: :frequency, model:, index:),
                    ])
        end

        [benefit_table] + benefits_add
      end
    end
  end
end
