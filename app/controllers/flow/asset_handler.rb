module Flow
  class AssetHandler
    ASSETS_ATTRIBUTES = (AssetsForm::ASSETS_ATTRIBUTES + [:assets]).freeze

    class << self
      def model(session_data)
        AssetsForm.new session_data.slice(*ASSETS_ATTRIBUTES.map(&:to_s))
      end

      def form(params, _session_data)
        AssetsForm.new(params.require(:assets_form).permit(*AssetsForm::ASSETS_ATTRIBUTES, assets: []))
      end
    end
  end
end
