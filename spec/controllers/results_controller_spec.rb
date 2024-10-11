require "rails_helper"

RSpec.describe ResultsController, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:email_address) { "test@testing.com" }
  let(:assessment_code) { "123456" }
  let(:session_data) { { "some" => "data", "assessment_code" => assessment_code } }
  let(:calculation_result) { instance_double(CalculationResult) }
  let(:check) { instance_double(Check, controlled?: false, early_ineligible_result?: false) }

  before do
    OmniAuth.config.mock_auth[:saml] = build(:mock_saml_auth)
    provider = create(:provider, email: email_address, first_office_code: "1Q630KL")
    sign_in provider

    allow(controller).to receive(:session_data).and_return(session_data)
    allow(CalculationResult).to receive(:new).and_return(calculation_result)
    allow(Check).to receive(:new).and_return(check)
    allow(controller).to receive(:track_page_view)
  end

  describe "GET #show" do
    context "when @check.early_ineligible_result? is true", :ee_banner do
      before do
        allow(check).to receive(:early_ineligible_result?).and_return(true)
      end

      it "does not call JourneyLoggerService" do
        expect(JourneyLoggerService).not_to receive(:call)
        get :show, params: { assessment_code: }
      end
    end

    context "when @check.early_ineligible_result? is false", :ee_banner do
      before do
        allow(check).to receive(:early_ineligible_result?).and_return(false)
      end

      it "calls JourneyLoggerService" do
        expect(JourneyLoggerService).to receive(:call).with(any_args)
        get :show, params: { assessment_code: }
      end
    end
  end
end
