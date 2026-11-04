require "rails_helper"

RSpec.describe "layouts/rcw/application", :embedded_only, ccq_mode: :embedded, type: :view do
  before do
    allow(ENV).to receive(:[]).and_call_original
    allow(ENV).to receive(:[]).with("GTM_CONTAINER_ID").and_return("GTM-TEST")
    allow(ENV).to receive(:[]).with("GA4_MEASUREMENT_ID").and_return("G-TEST")
    allow(ENV).to receive(:[]).with("ANALYTICS_ENVIRONMENT").and_return("staging")
    allow(view).to receive(:content_security_policy_nonce).and_return("ccq-nonce")
    allow(view).to receive(:t).and_call_original
    allow(view).to receive(:t).with("layouts.rcw.service.homepage_url").and_return("/")
  end

  it "includes the host analytics script with CCQ's nonce and shared consent" do
    cookies[CookiesController::COOKIE_CHOICE_NAME] = "accepted"

    render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

    script = Nokogiri::HTML(rendered).at_css('script[src="/js/analytics.js"]')
    expect(script).not_to be_nil
    expect(script.attributes.transform_values(&:value)).to include(
      "nonce" => "ccq-nonce",
      "defer" => "defer",
      "data-container-id" => "GTM-TEST",
      "data-measurement-id" => "G-TEST",
      "data-environment" => "staging",
      "data-consent" => "accepted",
    )
  end

  { nil => "none", "rejected" => "rejected", "unexpected" => "none" }.each do |choice, expected_consent|
    it "includes the shared script with consent #{expected_consent.inspect} for #{choice.inspect}" do
      cookies[CookiesController::COOKIE_CHOICE_NAME] = choice

      render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

      expect(Nokogiri::HTML(rendered).at_css('script[src="/js/analytics.js"]')["data-consent"]).to eq(expected_consent)
    end
  end

  %w[uat production].each do |environment|
    it "includes the shared script in #{environment}" do
      allow(ENV).to receive(:[]).with("ANALYTICS_ENVIRONMENT").and_return(environment)

      render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

      expect(Nokogiri::HTML(rendered).at_css('script[src="/js/analytics.js"]')["data-environment"]).to eq(environment)
    end
  end

  %w[GTM_CONTAINER_ID GA4_MEASUREMENT_ID ANALYTICS_ENVIRONMENT].each do |setting|
    [nil, "", "   "].each do |value|
      it "omits the shared script when #{setting} is #{value.inspect}" do
        allow(ENV).to receive(:[]).with(setting).and_return(value)

        render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

        expect(Nokogiri::HTML(rendered).at_css('script[src="/js/analytics.js"]')).to be_nil
      end
    end
  end

  it "omits the shared script for an unsupported analytics environment" do
    allow(ENV).to receive(:[]).with("ANALYTICS_ENVIRONMENT").and_return("development")

    render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

    expect(Nokogiri::HTML(rendered).at_css('script[src="/js/analytics.js"]')).to be_nil
  end

  it "never includes the standalone banner, container or noscript iframe" do
    cookies[CookiesController::COOKIE_CHOICE_NAME] = "accepted"
    allow(ENV).to receive(:[]).with("GOOGLE_TAG_MANAGER_ID").and_return("GTM-STANDALONE")

    render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

    document = Nokogiri::HTML(rendered)
    expect(document.at_css(".govuk-cookie-banner")).to be_nil
    expect(document.at_css('iframe, script[src*="googletagmanager.com"]')).to be_nil
    expect(rendered).not_to include("GTM-STANDALONE")
  end

  it "links the footer to the host cookies page even without analytics configuration" do
    allow(ENV).to receive(:[]).with("GTM_CONTAINER_ID").and_return(nil)

    render inline: "<h1>Assessment</h1>", layout: "layouts/rcw/application"

    link = Nokogiri::HTML(rendered).at_css('footer a[href="/cookies"]')
    expect(link).not_to be_nil
    expect(link.text).to eq("Cookies")
  end
end
