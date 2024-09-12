# frozen_string_literal: true

module CheckAnswers
  module Sections
    class CaseDetails < Base
      def initialize(check)
        super(check:, label: :case_details)
        @check = check
      end

      def subsections
        tables = [level_of_help_table]
        if @check.under_eighteen?
          tables += [aggregated_means_table] unless @check.controlled_clr? || !@check.controlled?
          tables += [immigration_or_asylum_table] if @check.under_eighteen_assets? || @check.under_eighteen_regular_income? || @check.aggregated_means?
          tables += [immigration_or_asylum_type_table, asylum_support_table] if @check.immigration_or_asylum? && !@check.controlled_clr?
        else
          tables += if @check.controlled?
                      [immigration_or_asylum_table]
                    else
                      [domestic_abuse_table, immigration_or_asylum_type_upper_tribunal_table]
                    end
          if @check.immigration_or_asylum?
            tables += if @check.controlled?
                        [immigration_or_asylum_type_table, asylum_support_table]
                      else
                        [asylum_support_table]
                      end
          end
        end
        [Subsection.new(tables:)]
      end

    private

      # skip_change_link is only set true when screen is set on the field.
      # Mostly it is set false and screen is nil other than level_of_help and domestic_abuse
      # where the reverse is true
      def level_of_help_table
        Table.new(screen: :level_of_help, skip_change_link: true, index: nil, disputed?: false,
                  fields: [
                    FieldWithScreenPresenter.new(table_label: :level_of_help, screen: :level_of_help, attribute: :level_of_help, type: :select, model: @check),
                    if @check.controlled? && @check.under_eighteen?
                      FieldWithScreenPresenter.new(table_label: :level_of_help, screen: :under_18_clr, attribute: :controlled_legal_representation, type: :boolean, model: @check)
                    end,
                  ].compact)
      end

      def domestic_abuse_table
        Table.new(screen: :domestic_abuse_applicant, skip_change_link: false, index: nil, disputed?: false,
                  fields: [
                    FieldPresenter.new(table_label: :domestic_abuse_applicant, attribute: :domestic_abuse_applicant, type: :boolean, model: @check),
                  ])
      end

      def aggregated_means_table
        Table.new(screen: :aggregated_means, skip_change_link: true, index: nil, disputed?: false,
                  fields: [
                    FieldWithScreenPresenter.new(table_label: :aggregated_means, screen: :aggregated_means, attribute: :aggregated_means, type: :boolean, model: @check),
                    unless @check.aggregated_means?
                      FieldWithScreenPresenter.new(table_label: :aggregated_means, screen: :regular_income, attribute: :regular_income, type: :boolean, model: @check)
                    end,
                    unless @check.under_eighteen_regular_income? || @check.aggregated_means?
                      FieldWithScreenPresenter.new(table_label: :aggregated_means, screen: :under_eighteen_assets, attribute: :under_eighteen_assets, type: :boolean, model: @check)
                    end,
                  ].compact)
      end

      def immigration_or_asylum_table
        Table.new(screen: :immigration_or_asylum, skip_change_link: false, index: nil, disputed?: false,
                  fields: [
                    FieldPresenter.new(table_label: :immigration_or_asylum, attribute: :immigration_or_asylum, type: :boolean, model: @check),
                  ])
      end

      def immigration_or_asylum_type_table
        Table.new(screen: :immigration_or_asylum_type, skip_change_link: false, index: nil, disputed?: false,
                  fields: [
                    FieldPresenter.new(table_label: :immigration_or_asylum_type, attribute: :immigration_or_asylum_type, type: :select, model: @check),
                  ])
      end

      def immigration_or_asylum_type_upper_tribunal_table
        Table.new(screen: :immigration_or_asylum_type_upper_tribunal, skip_change_link: false, index: nil, disputed?: false,
                  fields: [
                    FieldPresenter.new(table_label: :immigration_or_asylum_type_upper_tribunal, attribute: :immigration_or_asylum_type_upper_tribunal, type: :select, model: @check),
                  ])
      end

      def asylum_support_table
        Table.new(screen: :asylum_support, skip_change_link: false, index: nil, disputed?: false,
                  fields: [
                    FieldPresenter.new(table_label: :asylum_support, attribute: :asylum_support, type: :boolean, model: @check),
                  ])
      end
    end
  end
end
