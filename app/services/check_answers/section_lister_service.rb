module CheckAnswers
  class SectionListerService
    Section = Struct.new(:label, :screen, :subsections, keyword_init: true)
    Subsection = Struct.new(:label, :screen, :fields, keyword_init: true)
    Field = Struct.new(:label, :type, :value, :screen, :alt_value, :id, :disputed?, keyword_init: true)

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
      @session_data = session_data.with_indifferent_access
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
      section = "CheckAnswers::#{subsection_data[:model]}".constantize.from_session(@session_data) if subsection_data.key?(:model)
      fields = if section.present?
                 subsection_data[:fields].select { |f| section.display_fields.include? f.fetch(:attribute).to_sym }
               else
                 subsection_data[:fields]
               end

      Subsection.new(label: subsection_data[:label],
                     screen: subsection_data[:screen],
                     fields: build_fields(section,
                                          fields,
                                          subsection_data[:screen] || section_data[:screen],
                                          subsection_data[:label] || section_data[:label]))
    end

    def build_fields(section, field_set, parent_screen, label_set)
      if SUBSECTION_SPECIAL_CASES.include?(label_set.to_sym)
        return send(:"#{label_set}_fields")
      end

      field_set.map { build_field(section, _1, label_set, parent_screen) }.compact
    end

    def build_field(section, field_data, label_set, parent_screen)
      return unless StepsHelper.valid_step?(@model, (field_data[:screen] || parent_screen).to_sym)

      value = if section.present?
                section.public_send field_data.fetch(:attribute).to_sym
              else
                @session_data[field_data[:attribute]]
              end

      label = field_data.fetch(:label, field_data.fetch(:attribute))

      disputed = section.disputed_asset? field_data.fetch(:attribute).to_sym if section.present?

      Field.new(label: "#{label_set}_fields.#{label}",
                type: field_data[:type],
                value:,
                disputed?: disputed,
                screen: field_data[:screen],
                alt_value: @session_data[field_data[:alt_attribute]])
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
