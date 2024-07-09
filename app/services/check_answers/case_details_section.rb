# frozen_string_literal: true

module CheckAnswers
  class CaseDetailsSection
    def initialize check
      @check = check
    end

    def label
      :case_details
    end

    def subsections
      table_data = {
        level_of_help: {
          skip_change_link: true,
          fields: [
            FieldPresenter.new(table_label: :level_of_help, screen: :level_of_help, attribute: :level_of_help, type: :select, check: @check),
            FieldPresenter.new(table_label: :level_of_help, screen: :under_18_clr, attribute: :controlled_legal_representation, type: :boolean, check: @check),
          ]
        },
        aggregated_means: {
          skip_change_link: true,
          fields: [
            FieldPresenter.new(table_label: :aggregated_means, screen: :aggregated_means, attribute: :aggregated_means, type: :boolean, check: @check),
            FieldPresenter.new(table_label: :aggregated_means, screen: :regular_income, attribute: :regular_income, type: :boolean, check: @check),
            FieldPresenter.new(table_label: :aggregated_means, screen: :under_eighteen_assets, attribute: :under_eighteen_assets, type: :boolean, check: @check),
          ]
        },
        domestic_abuse_applicant: {
          skip_change_link: false,
          fields: [
            FieldPresenter.new(table_label: :domestic_abuse_applicant, screen: nil, attribute: :domestic_abuse_applicant, type: :boolean, check: @check),
          ]
        },
        immigration_or_asylum: {
          skip_change_link: false,
          fields: [
            FieldPresenter.new(table_label: :immigration_or_asylum, screen: nil, attribute: :immigration_or_asylum, type: :boolean, check: @check),
          ]
        },
        immigration_or_asylum_type: {
          skip_change_link: false,
          fields: [
            FieldPresenter.new(table_label: :immigration_or_asylum_type, screen: nil, attribute: :immigration_or_asylum_type, type: :select, check: @check),
          ]
        },
        immigration_or_asylum_type_upper_tribunal: {
          skip_change_link: false,
          fields: [
            FieldPresenter.new(table_label: :immigration_or_asylum_type_upper_tribunal, screen: nil, attribute: :immigration_or_asylum_type_upper_tribunal, type: :select, check: @check),
          ]
        },
        asylum_support: {
          skip_change_link: false,
          fields: [
            FieldPresenter.new(table_label: :asylum_support, screen: nil, attribute: :asylum_support, type: :boolean, check: @check),
          ]
        },
      }

      tables = table_data.map do |screen, data|
        table_fields = data.fetch(:fields).select { |f| f.screen.nil? || Steps::Helper.relevant_steps(@check.session_data).include?(f.screen) }
        Table.new(screen: screen, skip_change_link: data.fetch(:skip_change_link), index: nil, disputed?: false, fields: table_fields) if table_fields.any?
      end.compact

      [Subsection.new(tables: tables.select { |t| Steps::Helper.relevant_steps(@check.session_data).include?(t.screen) })]
    end
  end
end
