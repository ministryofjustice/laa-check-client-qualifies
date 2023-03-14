module CheckAnswers
  class SectionListerService
    Section = Struct.new(:label, :screen, :subsections, keyword_init: true)
    Subsection = Struct.new(:label, :screen, :fields, keyword_init: true)
    Field = Struct.new(:label, :type, :value, :screen_to_link_to, :alt_value, :disputed?, keyword_init: true)

    SUBSECTION_SPECIAL_CASES = %i[benefits partner_benefits].freeze

    def self.call(session_data)
      new(session_data).call
    end

    def call
      data = YAML.load_file(Rails.root.join("app/lib/check_answers_fields.yml")).with_indifferent_access
      data[:sections].map { build_section(_1) }.select { _1.subsections.any? }
    end

  private

    def initialize(session_data)
      @session_data = session_data.with_indifferent_access
      @model = EstimateModel.from_session(session_data)
      @disputed_asset_model = DisputedAssetModel.from_session(session_data)
    end

    def build_section(section_data)
      Section.new(label: section_data[:label],
                  screen: section_data[:screen],
                  subsections: build_subsections(section_data))
    end

    def build_subsections(section_data)
      section_data[:subsections].map { build_subsection(_1, section_data) }.select { _1.fields.any? }
    end

    def build_subsection(subsection_data, section_data)
      Subsection.new(label: subsection_data[:label],
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
      relevant_screen = (field_data[:screen] || field_data[:related_screen] || parent_screen).to_sym
      return unless StepsHelper.valid_step?(@model, relevant_screen)
      return if field_data[:skip_unless].present? && !@model.send(field_data[:skip_unless])

      label = field_data.fetch(:label, field_data.fetch(:attribute))

      Field.new(label: "#{label_set}_fields.#{label}",
                type: field_data[:type],
                value: @session_data[field_data[:attribute]],
                disputed?: @disputed_asset_model.disputed?(field_data.fetch(:attribute)),
                screen_to_link_to: (relevant_screen if field_data[:change_link]),
                alt_value: @session_data[field_data[:alt_attribute]])
    end

    def benefits_fields
      if StepsHelper.valid_step?(@model, :benefits)
        benefits_fields_common(session_key: "benefits")
      else
        []
      end
    end

    def partner_benefits_fields
      if StepsHelper.valid_step?(@model, :partner_benefits)
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
  end
end
