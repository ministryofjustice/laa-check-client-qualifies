# frozen_string_literal: true

class Provider < ApplicationRecord
  validates :email, presence: true
  validates :first_office_code, presence: true

  devise :database_authenticatable

  def encrypted_password; end
end

#------------------------------------------------------------------------------
# Provider
#
# Name              SQL Type             Null    Primary Default
# ----------------- -------------------- ------- ------- ----------
# id                bigint               false   true              
# email             character varying    false   false             
# created_at        timestamp(6) without time zone false   false             
# updated_at        timestamp(6) without time zone false   false             
# first_office_code character varying    true    false             
#
#------------------------------------------------------------------------------
