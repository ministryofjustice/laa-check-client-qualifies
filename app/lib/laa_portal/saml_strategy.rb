# frozen_string_literal: true

module LaaPortal
  class SamlStrategy < OmniAuth::Strategies::SAML
    # :nocov:
    def auth_hash
      hash = super

      Rails.logger.debug("auth_hash before #{hash.info}")

      hash.merge(
        info: {
          email: hash.info.email,
          roles: hash.info.roles.split(","),
          office_codes: hash.info.office_codes.to_s.split(":"),
        },
      ).tap do |auth|
        Rails.logger.debug("auth_hash after #{auth.info}")
      end
    end

    # temp - copy of gem code with logging added
    def handle_logout_request(raw_request, settings)
      logout_request = OneLogin::RubySaml::SloLogoutrequest.new(raw_request, {}.merge(settings: settings).merge(get_params: @request.params))

      valid_logout_request = logout_request.is_valid?(true)
      saml_uid = session["saml_uid"]
      if valid_logout_request &&
        logout_request.name_id == saml_uid

        # Actually log out this session
        options[:idp_slo_session_destroy].call @env, session

        # Generate a response to the IdP.
        logout_request_id = logout_request.id
        logout_response = OneLogin::RubySaml::SloLogoutresponse.new.create(settings, logout_request_id, nil, RelayState: slo_relay_state)
        redirect(logout_response)
      else
        if valid_logout_request
          raise OmniAuth::Strategies::SAML::ValidationError.new("SAMl Logout request failed: Name id #{logout_request.name_id} SAML_UID #{saml_uid}")
        else
          raise OmniAuth::Strategies::SAML::ValidationError.new("SAML Logout request failed: Errors #{logout_request.errors.inspect}")
        end
      end
    end

    # :nocov:
  end
end
