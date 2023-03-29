class ControlledWorkDocumentSelectionsController < ApplicationController
  def new
    @form = ControlledWorkDocumentSelection.new
    @check = Check.new(session_data)
  end

  def create
    @form = ControlledWorkDocumentSelection.new(params[:controlled_work_document_selection]&.permit(:form_type))
    if @form.valid?
      # TODO: Pick a document template based on @form.form_type and populate it
      # with appropriate session data rather than using a static PDF
      send_data File.open(Rails.root.join("lib/cw1-form.pdf")),
                filename: "cw1-form.pdf",
                type: "application/pdf"
    else
      @check = Check.new(session_data)
      render :new
    end
  end

private

  def assessment_code
    params[:estimate_id]
  end
end
