class ChangeLogs
  CHANGES = [
    { key: :dependant_allowance, show_from: "2023-4-4", change_on: "2023-4-10", show_until: "2023-5-4" },
  ].freeze

  class << self
    def for_banner
      CHANGES.select { Time.current.beginning_of_day >= _1[:show_from] && Time.current.beginning_of_day <= _1[:show_until] }
    end

    def last_updated_at
      occurred.map { Date.parse(_1[:change_on]) }.max.strftime("%-d %B %Y")
    end

    def occurred
      CHANGES.select { Time.current.beginning_of_day >= _1[:change_on] }
    end
  end
end
