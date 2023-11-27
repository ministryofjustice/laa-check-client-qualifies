class ApplicantForm
  include ActiveModel::Model
  include ActiveModel::Attributes
  include SessionPersistable

  ATTRIBUTES = %i[over_60 partner passporting].freeze

  ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: { in: [true, false] }, if: -> { attr != :over_60 || !FeatureFlags.enabled?(:under_eighteen, @check.session_data) }
  end
end
