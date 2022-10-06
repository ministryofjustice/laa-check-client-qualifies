require "rails_helper"
class MockableFaradayClient
  def post(*); end
end

RSpec.describe CfeConnection do
  it "reformats raised errors" do
    subject = described_class.new
    faraday_client = instance_double("MockableFaradayClient")
    allow(subject).to receive(:cfe_connection).and_return faraday_client
    allow(faraday_client).to receive(:post).and_return(OpenStruct.new(
                                                         status: 422,
                                                         body: "API error message",
                                                       ))

    expect { subject.create_dependants("id", 1) }.to raise_error(
      "Call to CFE url /assessments/id/dependants returned status 422 and message:\nAPI error message",
    )
  end
end
