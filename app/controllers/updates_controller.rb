class UpdatesController < ApplicationController
  before_action :track_page_view, only: :index

  def index; end
end
