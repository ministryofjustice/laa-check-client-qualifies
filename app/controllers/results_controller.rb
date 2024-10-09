class ResultsController < ApplicationController
  before_action :load_check, only: %i[show download]

  def create
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.relevant_steps(session_data))
    redirect_to result_path(assessment_code:)
  end

  def early_result
    # hard coding this at the moment - we could look for last step with valid data but that might cause issues if
    # banner displayed on multiple pages OR we can send the step down in the param?
    session_data["api_response"] = CfeService.call(session_data, Steps::Helper.completed_steps_for(session_data, :other_income))
    session_data["early_result"].merge!("type" => "gross_income")
    redirect_to result_path(assessment_code:)
  end

  def show
    @early_assessment = session_data.dig("early_result", "type")
    @early_eligibility_selection = session_data.fetch("early_eligibility_selection", nil)
    @model = CalculationResult.new(session_data)
    # we'll need to move this tracking point or do something with it
    track_completed_journey(@model)
    track_page_view(page: :view_results)
    @journey_continues_on_another_page = @check.controlled? && @model.decision == "eligible"
    @feedback = @journey_continues_on_another_page ? :freetext : :satisfaction
  end

  def download
    @early_assessment = session_data.dig("early_result", "type")
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
    if signed_in? && current_provider.present?
      JourneyLoggerService.call(assessment_id, calculation_result, @check, current_provider.first_office_code, cookies)
    else
      JourneyLoggerService.call(assessment_id, calculation_result, @check, nil, cookies)
    end
  end
end
