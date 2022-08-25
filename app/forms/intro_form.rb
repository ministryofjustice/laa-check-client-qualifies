class IntroForm
  include ActiveModel::Model
  include ActiveModel::Attributes

  INTRO_YES_NO_ATTRIBUTES = [:passporting, :over_60, :dependants, :partner].freeze
  INTRO_ATTRIBUTES = (INTRO_YES_NO_ATTRIBUTES + [:employed]).freeze

  INTRO_YES_NO_ATTRIBUTES.each do |attr|
    attribute attr, :boolean
    validates attr, inclusion: {in: [true, false], message: I18n.t("errors.mandatory_yes_no_question")}
  end

  attribute :employed, :boolean
  validates :employed, inclusion: {in: [true, false], message: I18n.t("errors.employment_status")}
end
