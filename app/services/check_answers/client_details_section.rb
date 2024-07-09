# frozen_string_literal: true

module CheckAnswers
  class ClientDetailsSection
    def initialize check
      @check = check
    end

    def label
      :client_details
    end

    def subsections
      [Subsection.new(tables: [
                        Table.new(screen: :client_age, index: nil, skip_change_link: false, disputed?: false,
                                  fields: [
                                    FieldPresenter.new(table_label: :client_age, screen: nil, attribute: :client_age, type: :select, check: @check),
                                  ]),
                        Table.new(screen: :applicant, index: nil, skip_change_link: false, disputed?: false,
                                  fields: [
                                    FieldPresenter.new(table_label: :applicant, screen: nil, attribute: :partner, type: :boolean, check: @check),
                                    FieldPresenter.new(table_label: :applicant, screen: nil, attribute: :passporting, type: :boolean, check: @check),
                                  ])
                      ])]
    end
  end
end