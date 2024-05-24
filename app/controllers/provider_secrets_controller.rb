# frozen_string_literal: true

# dummy secured endpoint for testing
class ProviderSecretsController < ApplicationController
  before_action :authenticate_provider!

  def index; end
end
