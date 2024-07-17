# frozen_string_literal: true

module Providers
  class SessionsController < Devise::SessionsController
    def after_sign_out_path_for(_resource_name)
      start_portal_signed_out_path
    end
  end
end
