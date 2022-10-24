class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  # def cfe_connection
  #   @cfe_connection ||= CfeConnection.connection
  # end

  def session_data(id = estimate_id)
    session[session_key(id)] ||= {}
  end

  def session_key(id)
    "estimate_#{id}"
  end
end
