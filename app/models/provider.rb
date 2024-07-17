# frozen_string_literal: true

class Provider < ApplicationRecord
  validates :email, presence: true

  devise :database_authenticatable

  def encrypted_password; end
end
