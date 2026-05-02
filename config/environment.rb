# Load the Rails application.
require_relative "application"

ActiveSupport::Notifications.subscribe("run_initializer.rails") do |_, _, _, _, payload|
  # Print the name of every initializer as it runs
  warn "=================================================="
  warn "Running initializer: #{payload[:initializer].name}"
end

begin
  # Initialize the Rails application.
  Rails.application.initialize!
rescue FrozenError => e
  warn e.backtrace
  warn "================ FROZEN ERROR ======================"

  raise e
end
