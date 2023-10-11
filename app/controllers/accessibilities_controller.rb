class AccessibilitiesController < ApplicationController
  before_action :track_page_view, only: :show

  def show; end

  def specify_feedback_widget
    @feedback = "none"
  end
end
