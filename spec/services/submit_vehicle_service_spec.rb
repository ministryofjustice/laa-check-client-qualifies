# require "rails_helper"
#
# RSpec.describe SubmitVehicleService do
#   let(:service) { described_class }
#   let(:session_data) do
#     {
#       "vehicle_owned"=>true,
#       "vehicle_value"=>"7000.0",
#       "vehicle_in_regular_use"=>true,
#       "vehicle_over_3_years_ago"=>true,
#       "vehicle_pcp"=>true,
#       "vehicle_finance"=>"2500.0"
#     }
#   end
#   let(:cfe_estimate_id) { SecureRandom.uuid }
#   let(:mock_connection) { instance_double(CfeConnection, create_assessment_id: cfe_estimate_id) }
#
#   describe ".call" do
#     before do
#       allow(CfeConnection).to receive(:connection).and_return(mock_connection)
#     end
#
#     context "when it is passed valid data" do
#       describe "with a main home with a mortgage" do
#         let(:value) { 7000.to_d }
#         let(:date_of_purchase) { 4.years.ago.to_date }
#         let(:loan_amount_outstanding) { 2500.to_d }
#         let(:in_regular_use) { true }
#
#
#         it "makes a successful call" do
#           expect(mock_connection).to receive(:create_vehicle).with(cfe_estimate_id,
#                                                                    date_of_purchase:,
#                                                                    value:,
#                                                                    loan_amount_outstanding:,
#                                                                    in_regular_use: )
#
#           service.call(cfe_estimate_id, session_data)
#         end
#       end
#     end
#   end
# end
