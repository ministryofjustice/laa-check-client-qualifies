class BenefitDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  attr_accessor :benefits

  ATTRIBUTES = %i[benefits].freeze

  SESSION_KEY = "benefits".freeze

  validate :benefits_valid?

  class << self
    def from_session(session_data)
      form = new
      form.benefits = session_data[self::SESSION_KEY]&.map do |benefits_attributes|
        BenefitModel.from_session(benefits_attributes)
      end

      if form.benefits.blank?
        form.benefits = [BenefitModel.new]
      end
      form
    end

    def from_params(params, _)
      form = new
      form.benefits = params.dig("benefit_model", "benefits").values.map do |benefits_attributes|
        BenefitModel.from_session(benefits_attributes)
      end
      form
    end

    def session_keys
      [self::SESSION_KEY]
    end
  end

  def session_attributes
    { self.class::SESSION_KEY => benefits.map(&:session_attributes) }
  end

  def benefit_list
    @benefit_list ||= begin
      display_list = cfe_benefit_list.reject { _1["exclude_from_gross_income"] || _1["label"].in?(PASSPORTED_BENEFITS) }
      display_list.map { _1["name"] }.uniq
    end
  end

private

  PASSPORTED_BENEFITS = %w[
    age_related_payment
    universal_credit
    income_support
    jobseekers_allowance
    employment_support_allowance
    pension_credit
  ].freeze

  def cfe_benefit_list
    CfeConnection.state_benefit_types
  end

  def benefits_valid?
    return if benefits.all?(&:valid?)

    benefits.each_with_index do |benefit, index|
      benefit.errors.messages.each do |field, messages|
        errors.add(:"benefits_#{index + 1}_#{field}", messages.first)
      end
    end
  end
end
