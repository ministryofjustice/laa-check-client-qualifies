class CwsController < ApplicationController
  def new; end

  def create
    send_data File.open(Rails.root.join("/lib/cw1-form.pdf")),
              filename: "cw1-form.pdf",
              type: "application/pdf"
  end

private

  def assessment_code
    params[:estimate_id]
  end
end
