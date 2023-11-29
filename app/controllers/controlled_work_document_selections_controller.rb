class ControlledWorkDocumentSelectionsController < ApplicationController
  def new
    track_page_view(page: :cw_form_selection)
    @form = ControlledWorkDocumentSelection.from_session(session_data)
    @check = Check.new(session_data)
    @model = CalculationResult.new(session_data)
  end

  def create
    @form = ControlledWorkDocumentSelection.from_params(params, session_data)
    if @form.valid?
      if FeatureFlags.enabled?(:end_of_journey, session_data)
        session_data.merge!(@form.attributes_for_export_to_session)
        redirect_to end_of_journey_path(assessment_code)
      else
        handle_download
      end
    else
      track_validation_error(page: :cw_form_selection)
      @check = Check.new(session_data)
      @model = CalculationResult.new(session_data)
      render :new
    end
  end

  def download
    @form = ControlledWorkDocumentSelection.from_session(session_data)
    handle_download
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def specify_feedback_widget
    @feedback = FeatureFlags.enabled?(:end_of_journey, session_data) ? :freetext : :satisfaction
  end

  def handle_download
    track_page_view(page: "download_#{@form.form_type}#{'_welsh' if @form.language == 'welsh'}")
    JourneyLogUpdateService.call(assessment_id, cookies, form_downloaded: true)
    ControlledWorkDocumentPopulationService.call(session_data, @form) do |file|
      prefix = "#{I18n.t('generic.welsh_in_welsh')} " if @form.language == "welsh"
      form_name = I18n.t("checks.end_of_journey.form_types.#{@form.form_type}")
      timestamp = Time.zone.now.in_time_zone("London").strftime("%Y-%m-%d %H.%M.%S")
      send_data file,
                filename: "#{prefix}#{form_name} #{timestamp}.pdf",
                type: "application/pdf"
    end
  end
end
