class UpdatesController < ApplicationController
  before_action :specify_feedback_widget, :track_page_view, only: :index

  def index; end

protected

  def specify_feedback_widget
    @feedback = :freetext
  end
end
