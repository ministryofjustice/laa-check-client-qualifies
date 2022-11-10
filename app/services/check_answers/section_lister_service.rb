module CheckAnswers
  class SectionListerService
    Section = Struct.new(:label, :screen, :subsections, keyword_init: true)
    Subsection = Struct.new(:label, :screen, :fields, keyword_init: true)
    Field = Struct.new(:label, :type, :value, :screen, :alt_value, :id, keyword_init: true)

    SUBSECTION_SPECIAL_CASES = %i[benefits].freeze

    def self.call(session_data)
      new(session_data).call
    end

    def call
      data = YAML.load_file(Rails.root.join("app/lib/check_answers_fields.yml")).with_indifferent_access
      data[:sections].map { build_section(_1) }.select { _1.subsections.any? }
    end

  private

    def initialize(session_data)
      @session_data = session_data
      @model = EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
    end

    def build_section(section_data)
      Section.new(label: section_data[:label],
                  screen: section_data[:screen],
                  subsections: build_subsections(section_data))
    end

    def build_subsections(section_data)
      return [] if section_data[:subsections].blank?

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
      value = build_value(field_data)

      return if !value && field_data["skip_if_null"]
      return unless StepsHelper.valid_step?(@model, (field_data[:screen] || parent_screen).to_sym)

      label = field_data.fetch(:label, field_data.fetch(:attribute))

      Field.new(label: "#{label_set}_fields.#{label}",
                type: field_data[:type],
                value:,
                screen: field_data[:screen],
                alt_value: @session_data[field_data[:alt_attribute]])
    end

    def build_value(field_data)
      if field_data[:requires_inclusion_in]
        key = field_data[:requires_inclusion_of] || field_data[:attribute]
        return unless @session_data[field_data[:requires_inclusion_in]]&.include?(key)
      end
      @session_data[field_data[:attribute]]
    end

    def benefits_fields
      return [] unless StepsHelper.valid_step?(@model, :benefits)

      if @session_data["benefits"].blank?
        return [Field.new(label: I18n.t("generic.not_applicable"),
                          type: "benefit")]
      end

      @session_data["benefits"].map do |benefit|
        Field.new(label: benefit["benefit_type"],
                  type: "benefit",
                  value: benefit["benefit_amount"],
                  alt_value: benefit["benefit_frequency"],
                  id: benefit["id"])
      end
    end
  end
end
