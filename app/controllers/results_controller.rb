class ResultsController < ApplicationController
  before_action :load_check, only: %i[show download]

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
    # ee_banner @early_eligibility_selection can be removed when FF is removed
    @early_result_type = session_data.dig("early_result", "type")
    @early_eligibility_selection = session_data.fetch("early_eligibility_selection", nil)
    @model = CalculationResult.new(session_data)

    track_completed_journey(@model) unless @check.early_ineligible_result?

    track_page_view(page: :view_results)
    @journey_continues_on_another_page = @check.controlled? && @model.decision == "eligible"
    @feedback = @journey_continues_on_another_page ? :freetext : :satisfaction
  end

  def download
    # ee_banner @early_eligibility_selection can be removed when FF is removed
    @early_result_type = session_data.dig("early_result", "type")
    @early_eligibility_selection = session_data.fetch("early_eligibility_selection", nil)
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
    office_code = signed_in? && current_provider.present? ? current_provider.first_office_code : nil

    JourneyLoggerService.call(assessment_id, calculation_result, @check, office_code, cookies)
  end
end
