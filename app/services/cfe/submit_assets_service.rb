module Cfe
  class SubmitAssetsService < BaseService
    delegate :smod_applicable?, to: :estimate

    def call(cfe_assessment_id)
      return unless relevant_form?(:assets)

      asset_form = ClientAssetsForm.from_session(@session_data)
      assets_in_dispute = smod_applicable? ? asset_form.in_dispute : []
      capitals = CfeParamBuilders::Capitals.call(asset_form, assets_in_dispute:)

      if capitals[:bank_accounts].any? || capitals[:non_liquid_capital].any?
        cfe_connection.create_capitals cfe_assessment_id, capitals
      end

      if asset_form.property_value.positive?
        second_property = {
          value: asset_form.property_value,
          outstanding_mortgage: asset_form.property_mortgage.strip,
          percentage_owned: asset_form.property_percentage_owned,
          subject_matter_of_dispute: (asset_form.property_in_dispute? && smod_applicable?) || false,
        }
      end

      if relevant_form?(:property_entry)
        property_form = PropertyForm.from_session(@session_data)
        property_entry_form = ClientPropertyEntryForm.from_session(@session_data)
        percentage_owned = if property_entry_form.joint_ownership
                             property_entry_form.percentage_owned + property_entry_form.joint_percentage_owned
                           else
                             property_entry_form.percentage_owned
                           end
        main_home = {
          value: property_entry_form.house_value,
          outstanding_mortgage: (property_entry_form.mortgage.strip if property_form.owned_with_mortgage?) || 0,
          percentage_owned:,
          subject_matter_of_dispute: (property_entry_form.house_in_dispute && smod_applicable?) || false,
        }
      elsif relevant_form?(:partner_property_entry)
        partner_property_form = PartnerPropertyForm.from_session(@session_data)
        partner_property_entry_form = PartnerPropertyEntryForm.from_session(@session_data)
        main_home = {
          value: partner_property_entry_form.house_value,
          outstanding_mortgage: (partner_property_entry_form.mortgage.strip if partner_property_form.owned_with_mortgage?) || 0,
          percentage_owned: partner_property_entry_form.percentage_owned,
          subject_matter_of_dispute: false,
        }
      end

      create_properties(cfe_assessment_id, main_home, second_property) if main_home.present? || second_property.present?
    end

  private

    def create_properties(assessment_id, main_property, second_property)
      main_home = main_property ||
        {
          value: 0,
          outstanding_mortgage: 0,
          percentage_owned: 0,
          subject_matter_of_dispute: false,
        }
      properties = { main_home: main_home.merge(shared_with_housing_assoc: false) }
      properties[:additional_properties] = [second_property.merge(shared_with_housing_assoc: false)] if second_property
      cfe_connection.create_properties(assessment_id, properties)
    end
  end
end
