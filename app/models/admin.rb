class Admin < ApplicationRecord
  # This model isn't actually database authenticable, but enabling this module (and adding the blank
  # password method below) turns on the behaviour where failed authentication checks redirect
  # to a sign-in page. We use that sign-in page as a discreet place for a 'sign in with Google'
  # button
  devise :database_authenticatable, :omniauthable, omniauth_providers: %i[google_oauth2]

  def encrypted_password; end
end
