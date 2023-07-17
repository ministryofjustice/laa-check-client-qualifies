class EstimatesController < ApplicationController
  before_action :redirect_to_primary_host, only: :new
  before_action :load_check, only: %i[check_answers show print download]

  def new
    new_assessment_code = SecureRandom.uuid
    session[assessment_id(new_assessment_code)] = { "feature_flags" => load_session_derived_flags }
    redirect_to estimate_build_estimate_path new_assessment_code, Steps::Helper.first_step
  end

  def create
    session_data["api_response"] = CfeService.call(session_data)
    redirect_to estimate_path(assessment_code)
  rescue Cfe::InvalidSessionError => e
    ErrorService.call(e)
    render :invalid_session
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

    PdfService.with_pdf_data_from_html_string(html, request.base_url) do |pdf_data|
      send_data pdf_data,
                filename: "#{I18n.t('generic.download_name')} - #{Time.zone.now.strftime('%Y-%m-%d %H.%M.%S')}.pdf",
                type: "application/pdf"
    end
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

  def load_session_derived_flags
    feature_flags = {}
    FeatureFlags::STATIC_FLAGS.select { |_, v| v == "session" }.map do |flag|
      feature_flags[flag.first.to_s] = FeatureFlags.enabled?(flag.first, without_session_data: true)
    end

    feature_flags
  end
end
