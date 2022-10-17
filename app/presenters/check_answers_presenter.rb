class CheckAnswersPresenter
  include StepsHelper

  def initialize(session_data)
    @session_data = session_data
    @model = EstimateModel.new session_data.slice(*EstimateModel::ESTIMATE_ATTRIBUTES.map(&:to_s))
  end

  def sections
    data = YAML.load_file(Rails.root.join("app/presenters/check_answers_fields.yml")).with_indifferent_access
    data[:sections].map { build_section(_1) }.select { _1.subsections.any? }
  end

  def build_section(section_data)
    OpenStruct.new(label: section_data[:label],
                   screen: section_data[:screen],
                   subsections: build_subsections(section_data))
  end

  def build_subsections(section_data)
    return [] if section_data[:subsections].blank?

    section_data[:subsections].map { build_subsection(_1, section_data) }.select { _1.fields.any? }
  end

  def build_subsection(subsection_data, section_data)
    OpenStruct.new(label: subsection_data[:label],
                   screen: subsection_data[:screen],
                   fields: build_fields(subsection_data[:fields],
                                        subsection_data[:screen] || section_data[:screen],
                                        subsection_data[:label] || section_data[:label]))
  end

  def build_fields(field_set, parent_screen, label_set)
    return [] if field_set.blank?

    field_set.map { build_field(_1, label_set) }.compact.select { valid_step?(_1.screen || parent_screen) }
  end

  def build_field(field_data, label_set)
    return if field_data[:skip_unless] && !@session_data[field_data[:skip_unless]]
    return if field_data[:skip_if] && @session_data[field_data[:skip_if]]

    OpenStruct.new(label: "#{label_set}_fields.#{field_data[:attribute]}",
                   type: field_data[:type],
                   value: build_value(field_data),
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

  def valid_step?(step_name)
    steps_list_for(@model).flatten.include?(step_name&.to_sym)
  end
end
