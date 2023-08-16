class Admin < ApplicationRecord
  devise :omniauthable, :rememberable, omniauth_providers: %i[google_oauth2]
end
