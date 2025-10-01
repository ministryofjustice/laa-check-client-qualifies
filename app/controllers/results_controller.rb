class ResultsController < ApplicationController
  before_action :load_check, only: %i[show download]
  before_action :specify_satisfaction_feedback_page_name

  def create
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.relevant_steps(session_data))
    redirect_to result_path(assessment_code:)
  end

  def early_result_redirect
    @previous_step = params[:step].to_sym
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.completed_steps_for(session_data, @previous_step))
    redirect_to result_path(assessment_code:)
  end

  def show
    @early_result_type = session_data.dig("early_result", "type")
    @model = CalculationResult.new(session_data)

    track_completed_journey(@model) unless @check.early_ineligible_result?

    track_page_view(page: :view_results)
    @journey_continues_on_another_page = @check.controlled? && @model.decision == "eligible"
  end

  def download
    @early_result_type = session_data.dig("early_result", "type")
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
                filename: "#{I18n.t('generic.download_name')} - #{helpers.timestamp_for_filenames}.pdf",
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

  def specify_feedback_widget
    @feedback = :satisfaction
  end

  def specify_satisfaction_feedback_page_name
    @satisfaction_feedback_page_name = page_name
  end
end
