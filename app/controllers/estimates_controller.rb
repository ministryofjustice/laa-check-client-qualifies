class EstimatesController < ApplicationController
  def new
    redirect_to estimate_build_estimate_path SecureRandom.uuid, StepsHelper.first_step
  end

  def create
    @model = CfeService.call(cfe_session_data(:estimate_id))
    render :show
  end

  def print
    @model = CfeService.call(cfe_session_data(:id))

    render :print, layout: "print_application"
  end

  def check_answers
    @form = CheckAnswersPresenter.new cfe_session_data(:id)
    @estimate_id = params.fetch(:id)
  end

  def download
    html = render_to_string({
      template: "estimates/print",
      layout: "print_application",
      locals: { :@model => CfeService.call(cfe_session_data(:id)) },
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

  def cfe_session_data(param_name)
    session_data params[param_name]
  end
end
