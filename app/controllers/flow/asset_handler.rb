module Flow
  class AssetHandler
    ASSETS_ATTRIBUTES = (AssetsForm::ASSETS_ATTRIBUTES + [:assets]).freeze

    class << self
      def model(session_data)
        AssetsForm.new session_data.slice(*ASSETS_ATTRIBUTES)
      end

      def form(params)
        AssetsForm.new(params.require(:assets_form).permit(*AssetsForm::ASSETS_ATTRIBUTES, assets: []))
      end

      def save_data(cfe_connection, estimate_id, estimate, _other)
        capitals = []
        capitals << OpenStruct.new(liquid?: true, amount: estimate.savings) if estimate.savings.present?
        capitals << OpenStruct.new(liquid?: false, amount: estimate.investments) if estimate.investments.present?
        cfe_connection.create_capitals estimate_id, capitals if capitals.any?
      end
    end
  end
end
