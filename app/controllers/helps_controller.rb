class HelpsController < ApplicationController
  before_action :specify_feedback_widget, :track_page_view, only: :show

  def show; end

protected

  def specify_feedback_widget
    @feedback = :freetext
  end
end
