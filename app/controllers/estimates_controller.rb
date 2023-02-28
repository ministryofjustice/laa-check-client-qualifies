class EstimatesController < ApplicationController
  before_action :load_estimate, only: %i[create print download]

  def new
    redirect_to estimate_build_estimate_path SecureRandom.uuid, StepsHelper.first_step
  end

  def create
    @model = CfeService.call(session_data)
    track_page_view(page: :view_results)
    render :show
  end

  def print
    @model = CfeService.call(session_data)
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
    @model = CfeService.call(session_data)
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
      emulate_media: "print",
      launch_args: ["--no-sandbox"],
      display_url: request.url.split("/estimates").first,
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

  def load_estimate
    @estimate = EstimateModel.from_session(session_data)
  end
end
