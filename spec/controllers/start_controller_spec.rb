require "rails_helper"

RSpec.describe StartController, type: :controller do
  describe "GET" do
    context "when I visit the non-primary host" do
      around do |spec|
        ENV["PRIMARY_HOST"] = "example2.com"
        spec.run
        ENV["PRIMARY_HOST"] = nil
      end

      it "redirects to the primary host" do
        get :index, params: { foo: "bar" }
        expect(response.headers["Location"]).to eq "http://example2.com/?foo=bar"
      end
    end

    context "when I visit the primary host" do
      around do |spec|
        # 'test.host' is the default request host in controller specs
        ENV["PRIMARY_HOST"] = "test.host"
        spec.run
        ENV["PRIMARY_HOST"] = nil
      end

      it "does not redirect" do
        get :index, params: { foo: "bar" }
        expect(response.headers["Location"]).to be_nil
      end
    end
  end
end
