class ControlledWorkDocumentSelectionsController < ApplicationController
  def new
    @form = ControlledWorkDocumentSelection.new
    @check = Check.new(session_data)
  end

  def create
    @form = ControlledWorkDocumentSelection.new(params[:controlled_work_document_selection]&.permit(:form_type))
    if @form.valid?
      ControlledWorkDocumentPopulationService.call(session_data, @form) do |file|
        send_data file,
                  filename: "controlled-work-form-#{assessment_code}.pdf",
                  type: "application/pdf"
      end
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
