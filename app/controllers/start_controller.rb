class StartController < ApplicationController
  before_action :redirect_to_primary_host, only: :index
  before_action :track_page_view, only: :index

  def index; end
end
