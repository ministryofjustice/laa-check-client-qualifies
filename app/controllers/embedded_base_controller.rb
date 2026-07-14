class EmbeddedBaseController < ApplicationController
  layout :embedded_layout_name

  skip_before_action :authenticate, :check_maintenance_mode, :specify_feedback_widget, :specify_freetext_feedback_page_name
  after_action :persist_journey_data, if: -> { @session_data_cache.present? }

  rescue_from Cfe::InvalidSessionError do
    redirect_to :landing
  end

  rescue_from ApplicationController::MissingSessionError do
    redirect_to :landing
  end

  around_action :tag_logs_with_resource_id

private

  def embedded_layout_name
    layout_name = ModeConfig.embedded_layout
    return layout_name if lookup_context.exists?(layout_name, "layouts", false)

    raise ArgumentError, "Unknown embedded layout '#{layout_name}'. Expected app/views/layouts/#{layout_name}.html.*"
  end

  def redirect_to_host_reauthentication(location:)
    if location.blank?
      Rails.logger.warn("#{self.class.name} received 302 from HostServiceClient without a Location header")
      render "errors/service_unavailable", status: :service_unavailable
      return
    end

    uri = URI.parse(location)
    query_params = Rack::Utils.parse_nested_query(uri.query)
    query_params["returnTo"] = host_reauthentication_return_path
    uri.query = query_params.to_query

    unless host_reauthentication_location_allowed?(uri)
      Rails.logger.warn(
        "#{self.class.name} received reauthentication Location with unexpected host from HostServiceClient: #{location.inspect}",
      )
      render "errors/service_unavailable", status: :service_unavailable
      return
    end

    redirect_to uri.to_s
  rescue URI::InvalidURIError, ActionController::Redirecting::UnsafeRedirectError
    Rails.logger.warn(
      "#{self.class.name} received invalid reauthentication Location from HostServiceClient: #{location.inspect}",
    )
    render "errors/service_unavailable", status: :service_unavailable
  end

  def host_reauthentication_location_allowed?(uri)
    return true if uri.host.blank?

    uri.host.casecmp?(request.host)
  end

  def host_reauthentication_return_path
    original_fullpath = request.original_fullpath
    return URI.parse(original_fullpath).path if original_fullpath.present?

    request.path
  rescue URI::InvalidURIError
    request.path
  end

  def journey_store
    @journey_store ||= JourneyDataStore::RedisStore.new(params[:resource_id])
  end

  def assessment_code
    params[:resource_id]
  end

  def session_data
    @session_data_cache ||= journey_store.read
  rescue JourneyDataStore::KeyNotFound
    raise ApplicationController::MissingSessionError
  end

  def persist_journey_data
    journey_store.write(@session_data_cache)
  end

  def tag_logs_with_resource_id(&block)
    Rails.logger.tagged("resource_id:#{params[:resource_id]}", &block)
  end
end
