class CannotUseServiceController < ApplicationController
  def additional_properties
    @check = Check.new(session_data)
    @previous_step = :additional_property
  end

private

  def assessment_code
    params[:assessment_code]
  end
end
