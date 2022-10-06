require "rails_helper"
class MockableFaradayError < Faraday::UnprocessableEntityError
  attr_accessor :response_body
end

class MockableFaradayClient
  def post(*); end
end

RSpec.describe CfeConnection do
  it "reformats raised errors" do
    subject = described_class.new
    faraday_client = instance_double("MockableFaradayClient")
    error = MockableFaradayError.new("Overall message")
    error.response_body = "Some response body"

    allow(subject).to receive(:cfe_connection).and_return faraday_client
    allow(faraday_client).to receive(:post).and_raise(error)

    expect { subject.create_dependants("id", 1) }.to raise_error(
      MockableFaradayError, "CFE returned the following message: Some response body"
    )
  end
end
