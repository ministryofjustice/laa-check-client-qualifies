class CannotUseServiceController < ApplicationController
  def additional_properties
    @check = Check.new(session_data)
    @previous_step = previous_step
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def previous_step
    params[:step]
  end
end
