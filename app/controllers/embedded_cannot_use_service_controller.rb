class EmbeddedCannotUseServiceController < EmbeddedBaseController
  include QuestionFlowMethods

  def show
    @check = Check.new(session_data)
    @previous_step = params[:step]
    @additional_property = %w[additional_property partner_additional_property].include?(@previous_step)
    track_page_view(page: page_name)
    render "cannot_use_service/show"
  end
end
