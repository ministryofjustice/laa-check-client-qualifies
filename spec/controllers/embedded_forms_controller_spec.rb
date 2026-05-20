# require "rails_helper"

# RSpec.describe EmbeddedFormsController, type: :controller do
#   let(:resource_id) { "test_resource_id" }
#   let(:session_data) { { "key" => "value" } }
#   let(:controller) { described_class.new.tap { |c| c.params = { resource_id: resource_id } } }
#   let(:journey_store) { instance_double(JourneyDataStore::SessionStore) }

#   before do
#     allow(JourneyDataStore::SessionStore).to receive(:new).with(session, anything).and_return(journey_store)
#     allow(journey_store).to receive(:read).and_return(session_data)
#   end

#   describe "GET #show" do
#   end
# end
