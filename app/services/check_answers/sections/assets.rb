# frozen_string_literal: true

module CheckAnswers
  module Sections
    class Assets < Base
      def initialize(check)
        super(check:, label: :assets)
      end

      def subsections
        [
          Subsection.new(tables: client_asset_tables),
          if @check.partner?
            Subsection.new(tables: partner_asset_tables)
          end,
          unless @check.controlled?
            Subsection.new(tables: vehicle_tables)
          end,
        ].compact
      end

    private

      def client_asset_tables
        asset_tables(screen: :assets, attribute_prefix: "", investments_disputed: @check.investments_in_dispute, valuables_disputed: @check.valuables_in_dispute)
      end

      def partner_asset_tables
        asset_tables(screen: :partner_assets, attribute_prefix: "partner_", investments_disputed: false, valuables_disputed: false)
      end

      def asset_tables(screen:, attribute_prefix:, investments_disputed:, valuables_disputed:)
        accounts = @check.public_send("#{attribute_prefix}bank_accounts") || []
        bank_fields = accounts.map.with_index do |account, index|
          MoneySubFieldPresenter.new(table_label: screen, attribute: :amount, index: index + 1, model: account, disputed: account.account_in_dispute)
        end

        table = Table.new(screen:, skip_change_link: false, index: nil, disputed?: nil,
                          fields:
                            bank_fields +
                            [
                              FieldPresenter.new(table_label: screen, attribute: "#{attribute_prefix}investments_relevant".to_sym, type: :boolean, model: @check),
                              if @check.public_send("#{attribute_prefix}investments_relevant?".to_sym)
                                MoneyPresenter.new(table_label: screen, attribute: "#{attribute_prefix}investments".to_sym, model: @check, disputed: investments_disputed)
                              end,
                              FieldPresenter.new(table_label: screen, attribute: "#{attribute_prefix}valuables_relevant".to_sym, type: :boolean, model: @check),
                              if @check.public_send("#{attribute_prefix}valuables_relevant?".to_sym)
                                MoneyPresenter.new(table_label: screen, attribute: "#{attribute_prefix}valuables".to_sym, model: @check, disputed: valuables_disputed)
                              end,
                            ].compact)
        [table]
      end

      def vehicle_tables
        table = Table.new(screen: :vehicle, skip_change_link: false, index: nil, disputed?: nil,
                          fields: [
                            FieldPresenter.new(table_label: :vehicle, attribute: :vehicle_owned, type: :boolean, model: @check, partner_dependant_wording: true),
                          ])
        add_another_tables = (@check.vehicles || []).map.with_index do |model, index|
          Table.new(screen: :vehicles_details, index:,
                    disputed?: model.vehicle_in_dispute, skip_change_link: false,
                    fields: [
                      MoneySubFieldPresenter.new(table_label: :vehicles_details, attribute: :vehicle_value,
                                                 model:, index:, disputed: false),
                      SubFieldPresenter.new(table_label: :vehicles_details, attribute: :vehicle_pcp, type: :boolean, model:),
                      if model.vehicle_pcp
                        MoneySubFieldPresenter.new(table_label: :vehicles_details, attribute: :vehicle_finance,
                                                   model:, index:, disputed: false)
                      end,
                      SubFieldPresenter.new(table_label: :vehicles_details, attribute: :vehicle_over_3_years_ago, type: :boolean, model:),
                      SubFieldPresenter.new(table_label: :vehicles_details, attribute: :vehicle_in_regular_use, type: :boolean, model:),
                    ].compact)
        end
        [table] + add_another_tables
      end
    end
  end
end
