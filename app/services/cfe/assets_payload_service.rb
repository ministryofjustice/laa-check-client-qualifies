module Cfe
  class AssetsPayloadService < BaseService
    delegate :smod_applicable?, to: :check

    def call
      capitals
      properties
    end

  private

    def capitals
      return unless relevant_form?(:assets)

      asset_form = instantiate_form(ClientAssetsForm)
      capitals = CfeParamBuilders::Capitals.call(asset_form, smod_applicable: smod_applicable?)

      return if capitals[:bank_accounts].none? && capitals[:non_liquid_capital].none?

      payload[:capitals] = capitals
    end

    def properties
      if relevant_form?(:additional_property_details)
        additionals_form = instantiate_form(AdditionalPropertyDetailsForm)
        additional_properties = additionals_form.items.map do |model|
          {
            value: model.house_value,
            outstanding_mortgage: (model.mortgage if model.owned_with_mortgage?) || 0,
            percentage_owned: model.percentage_owned,
            subject_matter_of_dispute: (model.house_in_dispute && smod_applicable?) || false,
            shared_with_housing_assoc: true,
          }
        end
      end

      if relevant_form?(:property_entry)
        property_entry_form = instantiate_form(PropertyEntryForm)
        main_home = {
          value: property_entry_form.house_value,
          outstanding_mortgage: (property_entry_form.mortgage if property_entry_form.owned_with_mortgage?) || 0,
          percentage_owned: property_entry_form.percentage_owned,
          subject_matter_of_dispute: (property_entry_form.house_in_dispute && smod_applicable?) || false,
          shared_with_housing_assoc: true,
        }
      end

      construct_properties(main_home, additional_properties) if main_home.present? || additional_properties.present?
    end

    def construct_properties(main_property, additional_properties)
      main_home = main_property ||
        {
          value: 0,
          outstanding_mortgage: 0,
          percentage_owned: 0,
          subject_matter_of_dispute: false,
          shared_with_housing_assoc: true,
        }
      properties = { main_home: }
      properties[:additional_properties] = additional_properties if additional_properties

      payload[:properties] = properties
    end
  end
end
