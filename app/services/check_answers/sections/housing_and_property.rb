# frozen_string_literal: true

module CheckAnswers
  module Sections
    class HousingAndProperty < Base
      def initialize(check)
        super(check:, label: :housing_and_property)
      end

      def subsections
        [
          Subsection.new(tables: property_tables),
          Subsection.new(tables: additional_property),
          if @check.partner?
            Subsection.new(tables: partner_additional_property)
          end,
        ].compact
      end

    private

      def property_tables
        property_table = Table.new(screen: :property,
                                   skip_change_link: false, index: nil, disputed?: nil,
                                   fields: [
                                     FieldPresenter.new(table_label: :property, attribute: :property_owned, type: :select, model: @check, partner_dependant_wording: true),
                                   ])
        housing_costs = unless @check.owns_property_outright?
                          Table.new(screen: :housing_costs, skip_change_link: false, index: nil, disputed?: nil,
                                    fields: housing_costs_fields(:housing_costs))
                        end
        mort_table = if @check.property_owned_with_mortgage?
                       Table.new(screen: :mortgage_or_loan_payment, skip_change_link: false, index: nil, disputed?: nil,
                                 fields: [
                                   MoneyWithFrequencyPresenter.new(table_label: :mortgage_or_loan_payment, attribute: :housing_loan_payments, model: @check,
                                                                   frequency_attribute: :housing_payments_loan_frequency),

                                 ])
                     end
        prop_entry_table = if @check.owns_property?
                             Table.new(screen: :property_entry, skip_change_link: false, index: nil, disputed?: @check.house_in_dispute,
                                       fields: [
                                         MoneyPresenter.new(table_label: :property_entry, attribute: :house_value, model: @check),
                                         if @check.property_owned_with_mortgage?
                                           MoneyPresenter.new(table_label: :property_entry, attribute: :mortgage, model: @check)
                                         end,
                                         FieldPresenter.new(table_label: :property_entry, attribute: :percentage_owned, type: :percentage, model: @check),
                                       ].compact)
                           end

        [property_table, housing_costs, mort_table, prop_entry_table].compact
      end

      def housing_costs_fields(label)
        [
          MoneyWithFrequencyPresenter.new(table_label: label, attribute: :housing_payments, model: @check,
                                          frequency_attribute: :housing_payments_frequency),
          FieldPresenter.new(table_label: label, attribute: :housing_benefit_relevant, type: :boolean, model: @check),
          if @check.housing_benefit_relevant?
            MoneyWithFrequencyPresenter.new(table_label: label, attribute: :housing_benefit_value, model: @check,
                                            frequency_attribute: :housing_benefit_frequency)
          end,
        ].compact
      end

      def additional_property
        additional_property_tables :additional_property, @check.additional_properties,
                                   :additional_property_details, :additional_property_owned
      end

      def partner_additional_property
        additional_property_tables :partner_additional_property, @check.partner_additional_properties,
                                   :partner_additional_property_details, :partner_additional_property_owned
      end

      def additional_property_tables(screen, additional_properties, details_screen, additional_property_attribute)
        additional = Table.new(screen:, skip_change_link: false, index: nil, disputed?: nil,
                               fields: [
                                 FieldPresenter.new(table_label: screen, attribute: additional_property_attribute, type: :select, model: @check),
                               ])
        property_tables = (additional_properties || []).map.with_index do |model, index|
          house_value = MoneySubFieldPresenter.new(table_label: details_screen, attribute: :house_value, index:, model:, disputed: false)
          inline_owned = if model.show_inline_mortgage_ownership_question?
                           SubFieldPresenter.new(table_label: details_screen, attribute: :inline_owned_with_mortgage, type: :boolean, model:)
                         end
          mortgage = if model.owned_with_mortgage?
                       MoneySubFieldPresenter.new(table_label: details_screen, attribute: :mortgage, model:, index:, disputed: false)
                     end
          percent = SubFieldPresenter.new(table_label: details_screen, attribute: :percentage_owned, type: :percentage, model:)

          Table.new(screen: details_screen, index:,
                    disputed?: model.house_in_dispute, skip_change_link: false,
                    fields: [house_value, inline_owned, mortgage, percent].compact)
        end
        [additional] + property_tables
      end
    end
  end
end
