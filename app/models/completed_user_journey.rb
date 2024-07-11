class CompletedUserJourney < ApplicationRecord
  attribute :assessment_id, :string
  attribute :session, :json
  attribute :certificated, :boolean
  attribute :partner, :boolean
  attribute :client_age, :string
  attribute :person_over_60, :boolean
  attribute :passported, :boolean
  attribute :main_dwelling_owned, :boolean
  attribute :vehicle_owned, :boolean
  attribute :smod_assets, :boolean
  attribute :outcome, :string
  attribute :capital_contribution, :boolean
  attribute :income_contribution, :boolean
  attribute :completed, :date
  attribute :form_downloaded, :boolean
  attribute :asylum_support, :boolean
  attribute :matter_type, :string
  attribute :office_code, :string
end
