module CheckAnswers
  class SectionListerService
    Section = Struct.new(:label, :screen, :subsections, keyword_init: true)
    Subsection = Struct.new(:label, :screen, :fields, keyword_init: true)
    Field = Struct.new(:label, :type, :value, :alt_value, :disputed?, keyword_init: true)

    SUBSECTION_SPECIAL_CASES = %i[benefits partner_benefits household_vehicles].freeze

    def self.call(session_data)
      new(session_data).call
    end

    def call
      data = YAML.load_file(section_yaml).with_indifferent_access
      data[:sections].map { build_section(_1) }.select { _1.subsections.any? }
    end

  private

    def initialize(session_data)
      @session_data = session_data.with_indifferent_access
      @model = Check.new(session_data)
      @disputed_asset_model = DisputedAssetModel.from_session(session_data)
    end

    def build_section(section_data)
      label = if section_data[:partner_dependant_wording] && @model.partner
                "#{section_data[:label]}_with_partner"
              else
                section_data[:label]
              end
      Section.new(label:,
                  screen: section_data[:screen],
                  subsections: build_subsections(section_data))
    end

    def build_subsections(section_data)
      section_data[:subsections].map { build_subsection(_1, section_data) }.select { _1.fields.any? }
    end

    def build_subsection(subsection_data, section_data)
      label = if subsection_data[:skip_header_unless_partner] && !@model.partner
                nil
              elsif subsection_data[:partner_dependant_wording] && @model.partner
                "#{subsection_data[:label]}_with_partner"
              else
                subsection_data[:label]
              end
      Subsection.new(label:,
                     screen: subsection_data[:screen],
                     fields: build_fields(subsection_data[:fields],
                                          subsection_data[:screen] || section_data[:screen],
                                          subsection_data[:label] || section_data[:label]))
    end

    def build_fields(field_set, parent_screen, label_set)
      if SUBSECTION_SPECIAL_CASES.include?(label_set.to_sym)
        return send(:"#{label_set}_fields")
      end

      field_set.map { build_field(_1, label_set, parent_screen) }.compact
    end

    def build_field(field_data, label_set, parent_screen)
      relevant_screen = (field_data[:screen] || parent_screen).to_sym
      return unless Steps::Helper.valid_step?(@model.session_data, relevant_screen)
      return if field_data[:skip_unless].present? && !@model.send(field_data[:skip_unless])

      label = field_data.fetch(:label, field_data.fetch(:attribute))

      Field.new(label: "#{label_set}_fields.#{label}",
                type: field_data[:type],
                value: @session_data[field_data[:attribute]],
                disputed?: @model.smod_applicable? && @disputed_asset_model.disputed?(field_data.fetch(:attribute)),
                alt_value: @session_data[field_data[:alt_attribute]])
    end

    def benefits_fields
      if Steps::Helper.valid_step?(@model.session_data, :benefits)
        benefits_fields_common(session_key: "benefits")
      else
        []
      end
    end

    def partner_benefits_fields
      if Steps::Helper.valid_step?(@model.session_data, :partner_benefits)
        benefits_fields_common(session_key: "partner_benefits")
      else
        []
      end
    end

    def benefits_fields_common(session_key:)
      if @session_data[session_key].blank?
        [Field.new(label: "benefits_fields.receives_benefits",
                   type: "boolean",
                   value: false)]
      else
        line_items = @session_data[session_key].map do |benefit|
          Field.new(label: benefit["benefit_type"],
                    type: "benefit",
                    value: benefit["benefit_amount"],
                    alt_value: benefit["benefit_frequency"])
        end
        [Field.new(label: "benefits_fields.receives_benefits",
                   type: "boolean",
                   value: true)] + line_items
      end
    end

    def household_vehicles_fields
      label = @model.partner ? "household_vehicles_fields.vehicle_owned_with_partner" : "household_vehicles_fields.vehicle_owned"
      if Steps::Helper.valid_step?(@model.session_data, :vehicles_details)
        line_items = @session_data["vehicles"].each_with_index.map do |vehicle, index|
          fields_for_vehicle(vehicle, index)
        end
        [Field.new(label:,
                   type: "boolean",
                   value: true)] + line_items.flatten
      elsif Steps::Helper.valid_step?(@model.session_data, :vehicle)
        [Field.new(label:,
                   type: "boolean",
                   value: false)]
      else
        []
      end
    end

    def fields_for_vehicle(vehicle, index)
      [
        Field.new(label: "household_vehicles_fields.vehicle", type: "header", value: index + 1, disputed?: @model.smod_applicable? && vehicle["vehicle_in_dispute"]),
        Field.new(label: "household_vehicles_fields.vehicle_value", type: "money", value: vehicle["vehicle_value"]),
        Field.new(label: "household_vehicles_fields.vehicle_pcp", type: "boolean", value: vehicle["vehicle_pcp"]),
        (Field.new(label: "household_vehicles_fields.vehicle_finance", type: "money", value: vehicle["vehicle_finance"]) if vehicle["vehicle_pcp"]),
        Field.new(label: "household_vehicles_fields.vehicle_over_3_years_ago", type: "boolean", value: vehicle["vehicle_over_3_years_ago"]),
        Field.new(label: "household_vehicles_fields.vehicle_in_regular_use", type: "boolean", value: vehicle["vehicle_in_regular_use"]),
      ].compact
    end

    def section_yaml
      path = if FeatureFlags.enabled?(:household_section)
               "app/lib/check_answers_fields.yml"
             else
               "app/lib/non_household_check_answers_fields.yml"
             end
      Rails.root.join(path)
    end
  end
end
