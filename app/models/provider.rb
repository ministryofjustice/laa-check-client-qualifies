# frozen_string_literal: true

class Provider < ApplicationRecord
  # attribute :email, :string
  # attribute :office_codes
  # attribute :roles

  # devise :database_authenticatable, :omniauthable, omniauth_providers: %i[saml]
  devise :database_authenticatable

  def encrypted_password; end
end
