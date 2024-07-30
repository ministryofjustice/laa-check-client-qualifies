module CheckAnswers
  class SectionListerService
    FieldData = Struct.new(:label, :type, :value, :alt_value, :relevancy_value, :disputed?, :index, :screen, keyword_init: true)

    def self.call(session_data)
      check = Check.new(session_data)
      new(check).call
    end

    def initialize(check)
      @check = check
    end

    def call
      filename = if FeatureFlags.enabled?(:legacy_assets_no_reveal, @check.session_data)
                   "app/lib/check_answers_fields_legacy.yml"
                 else
                   "app/lib/check_answers_fields.yml"
                 end
      data = YAML.load_file(Rails.root.join(filename)).with_indifferent_access
      sections = [
        ClientDetailsSection.new(@check),
        CaseDetailsSection.new(@check),
        DependantsSection.new(@check),
        ClientIncomeSection.new(@check),
        PartnerIncomeSection.new(@check),
      ] + data[:sections].map { build_section(_1) }
      sections.select do
        _1.subsections.any?
      end
    end

  private

    def build_section(section_data)
      Section.new(label: section_data[:label],
                  subsections: build_subsections(section_data))
    end

    def build_subsections(section_data)
      section_data[:subsections].map { build_subsection(_1) }.select { _1.tables.any? }
    end

    def build_subsection(subsection_data)
      Subsection.new(tables: build_tables(subsection_data))
    end

    def build_tables(subsection_data)
      standard = build_standard_tables(subsection_data)
      add_another = build_add_another_tables(subsection_data)
      (standard + add_another).compact.select { _1.fields.any? }
    end

    def build_standard_tables(subsection_data)
      return [] if subsection_data[:tables].blank?

      subsection_data[:tables].map { build_table(_1, @check) }
    end

    def build_add_another_tables(subsection_data)
      return [] if subsection_data[:add_another_tables].blank?

      subsection_data[:add_another_tables].map { build_add_another_table_set(_1) }.flatten
    end

    def build_add_another_table_set(add_another_table_set_data)
      models = @check.send(add_another_table_set_data[:attribute])
      return [] unless models

      models.each_with_index.map { |model, index| build_table(add_another_table_set_data, model, index:) }
    end

    def build_table(table_data, model, index: nil)
      return unless Steps::Helper.relevant_steps(@check.session_data).include?(table_data[:screen].to_sym)

      Table.new(
        screen: table_data[:screen],
        index:,
        disputed?: table_data[:disputed_if].present? && @check.smod_applicable? && model.send(table_data.fetch(:disputed_if)),
        fields: build_fields(model, table_data[:fields], table_data[:screen]),
        skip_change_link: table_data[:skip_change_link] == true,
      )
    end

    def build_fields(model, field_set, table_label)
      field_set.map { build_field(_1, model, table_label) }.flatten.compact
    end

    def build_field(field_data, model, table_label, index: nil)
      return build_many_fields(field_data, model, table_label) if field_data[:many]
      return if field_data[:skip_unless].present? && field_data[:skip_unless].split(",").any? { !model.send(_1) }
      # check_answers.yml uses skip_if, however we do not utilise this feature at present
      # instead of removing the line we skip coverage so that we can still use this if necessary
      # :nocov:
      return if field_data[:skip_if].present? && model.send(field_data[:skip_if])
      return if field_data[:screen] && !Steps::Helper.relevant_steps(@check.session_data).include?(field_data[:screen].to_sym)
      # :nocov:

      addendum = "_partner" if @check.partner && field_data[:partner_dependant_wording]

      disputed = field_data[:disputed_if].present? && @check.smod_applicable? && model.send(field_data.fetch(:disputed_if))

      FieldData.new(label: "#{table_label}_fields.#{field_data.fetch(:attribute)}#{addendum}",
                    type: field_data[:type].to_sym,
                    value: model.send(field_data[:attribute]),
                    disputed?: disputed,
                    index:,
                    screen: field_data[:screen],
                    alt_value: (model.send(field_data[:alt_attribute]) if field_data[:alt_attribute]),
                    relevancy_value: (model.send(field_data[:relevancy_attribute_name]) if field_data[:relevancy_attribute_name]))
    end

    def build_many_fields(field_data, model, table_label)
      submodel = model.send(field_data[:model])
      submodel.each_with_index.map { build_field(field_data[:template], _1, table_label, index: _2 + 1) }
    end
  end
end
