module Steps
  class AssetsSection
    class << self
      def all_steps
        %i[assets partner_details partner_assets]
      end

      def all_steps_for_current_feature_flags
        %i[assets partner_details partner_assets].freeze
      end

      def grouped_steps_for(session_data)
        return [] if Steps::Logic.asylum_supported?(session_data)

        if Steps::Logic.passported?(session_data)
          [Steps::Group.new(:assets),
           Steps::Group.new(:partner_details),
           Steps::Group.new(:partner_assets),
          ].compact
        else
          [Steps::Group.new(:assets),
           Steps::Group.new(:partner_assets)].compact
        end
      end
    end
  end
end
