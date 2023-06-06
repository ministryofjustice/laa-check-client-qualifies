class ChangeLogs
  UPDATES = [
    { key: :household_flow, change_on: "2023-6-6" },
  ].freeze

  BANNERS = [
    { key: :dependant_allowance, change_on: "2023-4-10", show_from: "2023-4-4", show_until: "2023-5-4" },
  ].freeze

  CHANGE_LOG = UPDATES + BANNERS

  class << self
    def for_banner_display
      BANNERS.select { Time.current.beginning_of_day >= _1[:show_from] && Time.current.beginning_of_day <= _1[:show_until] }
    end

    def last_updated_at
      occurred.map { Date.parse(_1[:change_on]) }.max.strftime("%-d %B %Y")
    end

    def occurred
      CHANGE_LOG.select { Time.current.beginning_of_day >= _1[:change_on] }
    end
  end
end
