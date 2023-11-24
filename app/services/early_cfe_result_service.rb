class EarlyCfeResultService
  class << self
    def call(step, session_data)
      case tag_from(step)
      when :employment_income, :benefits_income, :other_income, :partner_employment_income, :partner_benefits_income, :partner_other_income
        session_data["gross_income_early_result"] = CfeService.call(session_data, early_eligibility: tag_from(step))
      when :client_assets, :partner_assets
        session_data["capital_early_result"] = CfeService.call(session_data, early_eligibility: tag_from(step))
      when :disposable_income
        check_early_disposable_income_eligibility(session_data, step)
      end
    end

    def tag_from(step)
      return if Flow::Handler::STEPS.fetch(step)[:tag].nil?

      Flow::Handler::STEPS.fetch(step)[:tag]
    end

    def check_early_disposable_income_eligibility(session_data, step)
      remaining_steps = Steps::Helper.remaining_steps_for(session_data, step)
      return if remaining_steps.blank?

      remaining_tags = []
      remaining_steps.map do |remaining|
        remaining_tags << tag_from(remaining)
      end
      return unless !remaining_tags.compact.include?(:disposable_income) && tag_from(step) == :disposable_income

      session_data["disposable_income_early_result"] = CfeService.call(session_data, early_eligibility: :disposable_income)
    end
  end
end
