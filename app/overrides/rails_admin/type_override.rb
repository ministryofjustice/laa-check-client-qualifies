# frozen_string_literal: true

# This override allows us to register an additional type in the Rails Admin data type registry.
# It runs after Rails Admin engine is loaded.

module RailsAdmin
  class Timestamptz < RailsAdmin::Config::Fields::Types::Datetime
  end

  class TypeOverride
    RailsAdmin::Config::Fields::Types.register(RailsAdmin::Timestamptz)
  end
end
