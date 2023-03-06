class PartnerDetailsForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistableForPartner

  attr_accessor :passporting

  ATTRIBUTES = %i[over_60 employment_status].freeze

  attribute :over_60, :boolean
  validates :over_60, inclusion: { in: [true, false] }

  attribute :employment_status, :string
  validates :employment_status,
            inclusion: { in: ApplicantForm::EMPLOYMENT_STATUSES.map(&:to_s), allow_nil: false },
            if: -> { !passporting }

  class << self
    def from_session(session_data)
      super(session_data).tap { set_extra_properties(_1, session_data) }
    end

    def from_params(params, session_data)
      super(params, session_data).tap { set_extra_properties(_1, session_data) }
    end

    def set_extra_properties(form, session_data)
      form.passporting = session_data["passporting"]
    end
  end
end
