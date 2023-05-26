class EstimatesController < ApplicationController
  before_action :load_check, only: %i[check_answers show print download]

  def new
    new_assessment_code = SecureRandom.uuid
    session[assessment_id(new_assessment_code)] = {}
    redirect_to estimate_build_estimate_path new_assessment_code, Steps::Helper.first_step
  end

  def create
    session_data["api_response"] = CfeService.call(session_data)
    redirect_to estimate_path(assessment_code)
  end

  def show
    @model = CalculationResult.new(session_data)
    track_completed_journey(@model)
    track_page_view(page: :view_results)
  end

  def print
    @model = CalculationResult.new(session_data)
    @answers = CheckAnswersPresenter.new session_data
    track_page_view(page: :print_results)
    render :print, layout: "print_application"
  end

  def check_answers
    @answers = CheckAnswersPresenter.new session_data
    track_page_view(page: :check_answers)
  end

  def download
    track_page_view(page: :download_results)
    @model = CalculationResult.new(session_data)
    @answers = CheckAnswersPresenter.new(session_data)
    html = render_to_string({
      template: "estimates/print",
      layout: "print_application",
    })

    grover_options = {
      format: "A4",
      margin: {
        top: "2cm",
        bottom: "2cm",
        left: "1cm",
        right: "1cm",
      },
      emulate_media: "screen",
      launch_args: ["--font-render-hinting=medium", "--no-sandbox"],
      display_url: request.url.split("/estimates").first,
      execute_script: "document.querySelectorAll('button').forEach(el => el.style.display = 'none')",
    }

    pdf = Grover.new(html, **grover_options).to_pdf

    send_data pdf,
              filename: "#{I18n.t('generic.download_name')} - #{Time.zone.now.strftime('%Y-%m-%d %H.%M.%S')}.pdf",
              type: "application/pdf"
  end

private

  def assessment_code
    params[:id]
  end

  def load_check
    @check = Check.new(session_data)
  end

  def track_completed_journey(calculation_result)
    JourneyLoggerService.call(assessment_id, calculation_result, @check, cookies)
  end
end
