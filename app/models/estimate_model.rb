class EstimateModel
  include ActiveModel::Model
  include ActiveModel::Attributes

  def self.from_session(session_data)
    new(session_data.slice(*self::ATTRIBUTES.map(&:to_s)))
  end

  ESTIMATE_BOOLEANS = %i[asylum_support
                         over_60
                         passporting
                         vehicle_owned
                         vehicle_in_regular_use
                         partner
                         partner_vehicle_owned
                         vehicle_pcp
                         housing_benefit
                         child_dependants
                         adult_dependants
                         partner_child_dependants
                         partner_adult_dependants
                         partner_housing_benefit
                         partner_vehicle_pcp].freeze

  ESTIMATE_STRINGS = %i[level_of_help
                        proceeding_type
                        property_owned
                        partner_property_owned
                        employment_status
                        partner_employment_status].freeze
  # This is the set of attributes which affect the page flow
  ATTRIBUTES = (ESTIMATE_BOOLEANS + ESTIMATE_STRINGS).freeze

  ESTIMATE_BOOLEANS.each do |attr|
    attribute attr, :boolean
  end

  ESTIMATE_STRINGS.each do |attr|
    attribute attr, :string
  end

  def owns_property?
    %i[with_mortgage outright].map(&:to_s).include? property_owned
  end

  def partner_owns_property?
    %i[with_mortgage outright].map(&:to_s).include? partner_property_owned
  end

  def controlled?
    level_of_help == "controlled"
  end

  def upper_tribunal?
    proceeding_type&.in?(%w[IM030 IA031])
  end

  def asylum_support_and_upper_tribunal?
    upper_tribunal? && asylum_support
  end

  def employed?
    ApplicantForm::EMPLOYED_STATUSES.map(&:to_s).include? employment_status
  end

  def partner_employed?
    ApplicantForm::EMPLOYED_STATUSES.map(&:to_s).include? partner_employment_status
  end

  def use_legacy_proceeding_type?
    !controlled? && !FeatureFlags.enabled?(:asylum_and_immigration)
  end

  def smod_applicable?
    !upper_tribunal?
  end
end
