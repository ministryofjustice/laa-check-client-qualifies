class ApplicationController < ActionController::Base
  default_form_builder GOVUKDesignSystemFormBuilder::FormBuilder

private

  def cfe_connection
    @cfe_connection ||= CfeConnection.connection
  end
end
