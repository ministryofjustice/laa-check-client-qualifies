class CwsController < ApplicationController
  def new
    @form = CwSelection.new
    @estimate = EstimateModel.from_session(session_data)
  end

  def create
    @form = CwSelection.new(params[:cw_selection]&.permit(:form_type))
    if @form.valid?
      send_data File.open(Rails.root.join("lib/cw1-form.pdf")),
                filename: "cw1-form.pdf",
                type: "application/pdf"
    else
      @estimate = EstimateModel.from_session(session_data)
      render :new
    end
  end

private

  def assessment_code
    params[:estimate_id]
  end
end
