# frozen_string_literal: true

module LaaPortal
  # :nocov:
  class SamlSetup
    class << self
      def call(env)
        return if OmniAuth.config.test_mode

        request = ActionDispatch::Request.new(env)

        portal_metadata_file = ENV.fetch("LAA_PORTAL_IDP_METADATA_FILE", "config/saml/metadata/portal-idp-dev.xml")

        config_metadata = metadata_config(ENV["LAA_PORTAL_IDP_METADATA_URL"],
                                          portal_metadata_file)

        parse_metadata_and_merge(env, config_metadata.merge(
                                        idp_sso_service_binding: :redirect,
                                        idp_slo_service_binding: :redirect,
                                        single_logout_service_url: sp_single_logout_url(request),
                                      ))
      end

    private

      def sp_single_logout_url(request)
        "#{request.base_url}/providers/auth/saml/slo"
      end

      def idp_metadata_parser
        OneLogin::RubySaml::IdpMetadataParser.new
      end

      def parse_metadata_and_merge(env, config)
        env["omniauth.strategy"].options.merge!(config)
      end

      def metadata_config(metadata_url, metadata_file)
        if metadata_url.present?
          metadata_from_server metadata_url
        elsif metadata_file.present?
          metadata_from_file metadata_file
        else
          raise "Either metadata URL or metadata file must be configured"
        end
      rescue StandardError => e
        if e.is_a?(Timeout::Error)
          e = StandardError.new(
            "Execution expired parsing remote metadata: `#{metadata_url}`",
          )
        end

        Rails.error.report(e, handled: false)
        raise(e) # re-raise exception
      end

      def metadata_from_server(metadata_url)
        # An explicit timeout is set, as the gem parser does not have one,
        # which means it hangs for a very long time if URL is not reachable.
        Timeout.timeout(3) do
          idp_metadata_parser.parse_remote_to_hash(metadata_url)
        end
      end

      def metadata_from_file(metadata_file)
        idp_metadata_parser.parse_to_hash(
          Rails.root.join(metadata_file).read,
        )
      end
    end
  end
  # :nocov:
end
