# This class is passed the session data for a given check (including the API response from CFE)
# as well as the name of a type of controlled work form, and uses that information to load
# a PDF version of the given form, pre-populate it with relevant information derived from
# the session, and yield the result as a file.

# It delegates the construction of the relevant values to a ControlledWorkDocumentValueMappingService,
# to which it passes a bunch of "mapping" config which it loads from a file depending on which
# form is to be populated.
class ControlledWorkDocumentPopulationService
  class << self
    def call(session_data, form_type)
      form_key = pick_form_key(form_type)

      Dir.mktmpdir do |dir|
        file_name = "#{dir}/output-form.pdf"
        pdftk = PdfForms.new(`which pdftk`.chomp)
        pdftk.fill_form template_path(form_key), file_name, values(session_data, form_key)
        yield File.read(file_name).force_encoding("BINARY")
      end
    end

    TEMPLATES = {
      "cw1" => "lib/cw1-form.pdf",
      "cw2" => "lib/cw2imm-form.pdf",
      "cw2_mtr_phase_1" => "lib/cw2imm-form-mtr-phase-1.pdf",
      "cw5" => "lib/cw5-form.pdf",
      "cw1_and_2" => "lib/cw1-and-2-form.pdf",
      "cw1_and_2_mtr_phase_1" => "lib/cw1-and-2-form-mtr-phase-1.pdf",
      "civ_means_7" => "lib/civ-means-7-form.pdf",
    }.freeze

    def template_path(form_key)
      Rails.root.join(TEMPLATES.fetch(form_key))
    end

    def values(session_data, form_key)
      mappings = YAML.load_file(Rails.root.join("app/lib/controlled_work_mappings/#{form_key}.yml")).map(&:with_indifferent_access)
      ControlledWorkDocumentValueMappingService.call(session_data, mappings)
    end

    def pick_form_key(form_type)
      return form_type unless FeatureFlags.enabled?(:mtr_phase_1, without_session_data: true)

      "#{form_type}_mtr_phase_1"
    end
  end
end
