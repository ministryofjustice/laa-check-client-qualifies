class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  def session_data(id = estimate_id)
    session[session_key(id)] ||= {}
  end

  def session_key(id)
    "estimate_#{id}"
  end
end
