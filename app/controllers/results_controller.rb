class ResultsController < ApplicationController
  before_action :load_check, only: %i[show download]

  def create
    session_data["api_response"] = CfeService.call(session_data)
    redirect_to result_path(assessment_code:)
  rescue Cfe::InvalidSessionError => e
    ErrorService.call(e)
    render :invalid_session
  end

  def show
    @model = CalculationResult.new(session_data)
    track_completed_journey(@model)
    track_page_view(page: :view_results)
    @journey_continues_on_another_page = FeatureFlags.enabled?(:end_of_journey, session_data) && @check.controlled? && @model.decision == "eligible" && !@check.asylum_support
    @feedback = @journey_continues_on_another_page ? :freetext : :satisfaction
  end

  def download
    track_page_view(page: :download_results)
    @model = CalculationResult.new(session_data)
    @sections = CheckAnswers::SectionListerService.call(session_data)
    @is_pdf = true
    html = render_to_string({
      template: "results/download",
      layout: "download_application",
    })

    PdfService.with_pdf_data_from_html_string(html, request.base_url) do |pdf_data|
      send_data pdf_data,
                filename: "#{I18n.t('generic.download_name')} - #{Time.zone.now.in_time_zone('London').strftime('%Y-%m-%d %H.%M.%S')}.pdf",
                type: "application/pdf"
    end
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def load_check
    @check = Check.new(session_data)
  end

  def track_completed_journey(calculation_result)
    JourneyLoggerService.call(assessment_id, calculation_result, @check, cookies)
  end
end
