require "rails_helper"

RSpec.describe ApplicationController, type: :controller do
  controller do
    # Anonymous controller inheriting from ApplicationController
    def index
      render json: { status: "ok" }
    end
  end

  describe "#ensure_db_connection" do
    context "when ActiveRecord::Base.connection raises StandardError" do
      it "returns nil and handles the error gracefully" do
        # Mock the connection to raise StandardError during reconnect
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)
        allow(ActiveRecord::Base.connection).to receive(:reconnect!).and_raise(StandardError, "Connection error")

        # The ensure_db_connection method is called as a before_action, so we trigger it by making a request
        expect { get :index }.not_to raise_error

        # The controller should still respond normally despite the database connection error
        expect(response).to have_http_status(:success)
      end
    end
  end
end
