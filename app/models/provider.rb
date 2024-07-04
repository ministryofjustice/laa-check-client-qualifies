# frozen_string_literal: true

class Provider < ApplicationRecord
  validates_presence_of :email

  devise :database_authenticatable

  def encrypted_password; end
end
