# Be sure to restart your server when you modify this file.

# Define an application-wide content security policy.
# See the Securing Rails Applications Guide for more information:
# https://guides.rubyonrails.org/security.html#content-security-policy-header

Rails.application.configure do
  config.content_security_policy do |policy|
    policy.default_src :self, :https
    policy.font_src    :self, :https, :data
    policy.img_src     :self, :https, :data
    policy.object_src  :none

    # This is the SHA for the inline javascript used by the static service unavailable page (as it's static, it can't use a nonce)
    policy.script_src  "'sha256-+6WnXIl4mbFTCARd8N3COQmT3bJJmo32N8q8ZSQAIcU='", :self, :https, :report_sample

    # These are the SHAs for the inline CSS used by the static service unavailable and not found pages
    # (as they're static, they can't use a nonce)
    policy.style_src "'sha256-77rnAjTWIfn0C+JGy/VQ5ZlAh2ZNEkgbAZfHP+ot9k0='",
                     "'sha256-SKk0A/cx4rPskCI+pT65OEYkqpmpNRbLvwc1gsUtf6s='",
                     :self, :https, :report_sample

    # Specify URI for violation reports
    policy.report_uri(ENV["CSP_REPORT_ENDPOINT"]) if ENV["CSP_REPORT_ENDPOINT"].present?
  end

  # Generate session nonces for permitted importmap and inline scripts
  config.content_security_policy_nonce_generator = ->(request) { request.session.id.to_s }
  config.content_security_policy_nonce_directives = %w[script-src]

  # Report violations without enforcing the policy.
  # config.content_security_policy_report_only = true
end
