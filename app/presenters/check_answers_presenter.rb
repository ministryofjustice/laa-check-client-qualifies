class CheckAnswersPresenter
  Section = Struct.new(:label, :screen, :subsections, keyword_init: true)
  Subsection = Struct.new(:label, :screen, :fields, keyword_init: true)
  Field = Struct.new(:label, :type, :value, :screen, :alt_value, keyword_init: true)

  def initialize(session_data)
    @session_data = session_data
    @model = EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
  end

  def sections
    data = YAML.load_file(Rails.root.join("app/presenters/check_answers_fields.yml")).with_indifferent_access
    data[:sections].map { build_section(_1) }.select { _1.subsections.any? }
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
    return [] if field_set.blank?

    field_set.map { build_field(_1, label_set, parent_screen) }.compact
  end

  def build_field(field_data, label_set, parent_screen)
    value = build_value(field_data)
    screen = build_screen(field_data, value)

    return unless StepsHelper.valid_step?(@model, (screen || parent_screen).to_sym)

    Field.new(label: "#{label_set}_fields.#{field_data[:attribute]}",
              type: field_data[:type],
              value:,
              screen:,
              alt_value: @session_data[field_data[:alt_attribute]])
  end

  def build_screen(field_data, value)
    return field_data[:screen_if_null] if field_data[:screen_if_null].present? && value.nil?

    field_data[:screen]
  end

  def build_value(field_data)
    if field_data[:requires_inclusion_in]
      key = field_data[:requires_inclusion_of] || field_data[:attribute]
      return unless @session_data[field_data[:requires_inclusion_in]]&.include?(key)
    end
    @session_data[field_data[:attribute]]
  end
end
