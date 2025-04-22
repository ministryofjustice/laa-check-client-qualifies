require "rails_helper"

RSpec.describe ControlledWorkDocumentPopulationService do
  describe ".call" do
    let(:pdftk_instance) { double("PdfForms", fill_form: true, call_pdftk: true) }
    let(:template_path) { "template/path.pdf" }
    let(:filled_path) { /filled-form\.pdf$/ }
    let(:background_path) { "lib/CWforms_SharedOwnership_english.pdf" }
    let(:file_name) { /output-form\.pdf$/ }
    let(:session_data) { { "property_owned" => property_status } }

    let(:model) do
      double(
        form_type: "SharedOwnership",
        language: "english",
      )
    end

    before do
      allow(PdfForms).to receive(:new).and_return(pdftk_instance)
      allow(described_class).to receive_messages(template_path: template_path, values: {})
      allow(File).to receive(:read).and_return("PDF_CONTENT")
      allow(FileUtils).to receive(:cp).and_return(true)
    end

    context "when shared ownership" do
      let(:property_status) { "shared_ownership" }

      before do
        allow(Steps::Logic).to receive(:owns_property_shared_ownership?).with(session_data).and_return(true)
      end

      it "calls pdftk with background_path" do
        expect(pdftk_instance).to receive(:call_pdftk).with(filled_path, "background", background_path, "output", file_name)
        described_class.call(session_data, model) { |_| }
      end
    end

    context "when property owned outright" do
      let(:property_status) { "outright" }

      before do
        allow(Steps::Logic).to receive(:owns_property_shared_ownership?).with(session_data).and_return(false)
      end

      it "does not call pdftk#call_pdftk" do
        expect(pdftk_instance).not_to receive(:call_pdftk)
        described_class.call(session_data, model) { |_| }
      end
    end
  end
end
