class EmbeddedBaseController < ApplicationController
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
