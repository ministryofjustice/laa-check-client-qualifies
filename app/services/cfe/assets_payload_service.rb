module Cfe
  class AssetsPayloadService
    class << self
      def call(session_data, payload, relevant_steps)
        capitals session_data, payload, relevant_steps
        properties session_data, payload
      end

    private

      def capitals(session_data, payload, completed_steps)
        return unless BaseService.completed_form?(completed_steps, :assets)

        check = Check.new session_data
        # return if check.non_means_tested?

        asset_form = BaseService.instantiate_form(session_data, ClientAssetsForm)
        capitals = CfeParamBuilders::Capitals.call(asset_form, smod_applicable: check.smod_applicable?)

        return if capitals[:bank_accounts].none? && capitals[:non_liquid_capital].none?

        payload[:capitals] = capitals
      end

      def properties(session_data, payload)
        check = Check.new session_data
        # if BaseService.completed_form?(completed_steps, :additional_property_details)
        if check.owns_additional_property?
          additionals_form = BaseService.instantiate_form(session_data, AdditionalPropertyDetailsForm)
          additional_properties = additionals_form.items.map do |model|
            {
              value: model.house_value,
              outstanding_mortgage: (model.mortgage if model.owned_with_mortgage?) || 0,
              percentage_owned: model.percentage_owned,
              subject_matter_of_dispute: (model.house_in_dispute && check.smod_applicable?) || false,
              shared_with_housing_assoc: false,
            }
          end
        end

        # if BaseService.completed_form?(completed_steps, :property_entry)
        if check.owns_property?
          property_entry_form = BaseService.instantiate_form(session_data, PropertyEntryForm)
          main_home = {
            value: property_entry_form.house_value,
            outstanding_mortgage: (property_entry_form.mortgage if property_entry_form.owned_with_mortgage?) || 0,
            percentage_owned: property_entry_form.percentage_owned,
            subject_matter_of_dispute: (property_entry_form.house_in_dispute && check.smod_applicable?) || false,
            shared_with_housing_assoc: false,
          }
        end

        construct_properties(payload, main_home, additional_properties) if main_home.present? || additional_properties.present?
      end

      def construct_properties(payload, main_property, additional_properties)
        main_home = main_property ||
          {
            value: 0,
            outstanding_mortgage: 0,
            percentage_owned: 0,
            subject_matter_of_dispute: false,
            shared_with_housing_assoc: false,
          }
        properties = { main_home: }
        properties[:additional_properties] = additional_properties if additional_properties

        payload[:properties] = properties
      end
    end
  end
end
