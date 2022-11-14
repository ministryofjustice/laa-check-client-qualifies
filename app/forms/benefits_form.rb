class BenefitsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = [:add_benefit].freeze

  attribute :add_benefit, :boolean
  validates :add_benefit, inclusion: { in: [true, false] }

  attr_accessor :benefits

  def self.from_session(session_data)
    super(session_data).tap { add_benefits(_1, session_data) }
  end

  def self.from_params(params, session_data)
    super(params, session_data).tap { add_benefits(_1, session_data) }
  end

  def self.add_benefits(form, session_data)
    form.benefits = session_data["benefits"]&.map do |benefits_attributes|
      BenefitModel.from_session(benefits_attributes)
    end
  end
end
