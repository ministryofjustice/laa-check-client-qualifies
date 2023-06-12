module Cfe
  class AssetsPayloadService < BaseService
    delegate :smod_applicable?, to: :check

    def call
      return unless relevant_form?(:assets)

      asset_form = ClientAssetsForm.from_session(@session_data)
      assets_in_dispute = smod_applicable? ? asset_form.in_dispute : []
      capitals = CfeParamBuilders::Capitals.call(asset_form, assets_in_dispute:)

      if capitals[:bank_accounts].any? || capitals[:non_liquid_capital].any?
        payload[:capitals] = capitals
      end
      second_property = if relevant_form?(:additional_property_details)
                          additional_property = AdditionalPropertyDetailsForm.from_session(@session_data)
                          {
                            value: additional_property.house_value,
                            outstanding_mortgage: (additional_property.mortgage if additional_property.owned_with_mortgage?) || 0,
                            percentage_owned: additional_property.percentage_owned,
                            subject_matter_of_dispute: (additional_property.house_in_dispute && smod_applicable?) || false,
                          }
                        end

      if relevant_form?(:property_entry)
        property_entry_form = ClientPropertyEntryForm.from_session(@session_data)
        main_home = {
          value: property_entry_form.house_value,
          outstanding_mortgage: (property_entry_form.mortgage if property_entry_form.owned_with_mortgage?) || 0,
          percentage_owned: property_entry_form.percentage_owned,
          subject_matter_of_dispute: (property_entry_form.house_in_dispute && smod_applicable?) || false,
        }
      end

      create_properties(main_home, second_property) if main_home.present? || second_property.present?
    end

  private

    def create_properties(main_property, second_property)
      main_home = main_property ||
        {
          value: 0,
          outstanding_mortgage: 0,
          percentage_owned: 0,
          subject_matter_of_dispute: false,
        }
      properties = { main_home: main_home.merge(shared_with_housing_assoc: false) }
      properties[:additional_properties] = [second_property.merge(shared_with_housing_assoc: false)] if second_property
      payload[:properties] = properties
    end
  end
end
