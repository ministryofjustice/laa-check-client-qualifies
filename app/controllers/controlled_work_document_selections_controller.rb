class ControlledWorkDocumentSelectionsController < ApplicationController
  def new
    track_page_view(page: :cw_form_selection)
    @form = ControlledWorkDocumentSelection.new
    @check = Check.new(session_data)
    @model = CalculationResult.new(session_data)
  end

  def create
    @form = ControlledWorkDocumentSelection.new(params[:controlled_work_document_selection]&.permit(:form_type, :language))
    if @form.valid?
      track_page_view(page: "download_#{@form.form_type}#{'_welsh' if @form.language == 'welsh'}")
      JourneyLogUpdateService.call(assessment_id, cookies, form_downloaded: true)
      ControlledWorkDocumentPopulationService.call(session_data, @form) do |file|
        send_data file,
                  filename: "controlled-work-form-#{assessment_code}.pdf",
                  type: "application/pdf"
      end
    else
      track_validation_error(page: :cw_form_selection)
      @check = Check.new(session_data)
      @model = CalculationResult.new(session_data)
      render :new
    end
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def specify_feedback_widget
    @feedback = :satisfaction
  end
end
