# frozen_string_literal: true

module CheckAnswers
  module Sections
    class ClientDetails < Base
      def initialize(check)
        super(check:, label: :client_details)
      end

      def subsections
        tables = [
          Table.new(screen: :client_age, index: nil, skip_change_link: false, disputed?: false,
                    fields: [
                      FieldPresenter.new(table_label: :client_age, attribute: :client_age, type: :select, model: @check),
                    ]),
          unless @check.non_means_tested?
            Table.new(screen: :applicant, index: nil, skip_change_link: false, disputed?: false,
                      fields: [
                        FieldPresenter.new(table_label: :applicant, attribute: :partner, type: :boolean, model: @check),
                        FieldPresenter.new(table_label: :applicant, attribute: :passporting, type: :boolean, model: @check),
                      ])
          end,
        ].compact

        [Subsection.new(tables: tables.compact)]
      end
    end
  end
end
