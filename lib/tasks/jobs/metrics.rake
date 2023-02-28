namespace :job do
  namespace :metrics do
    desc "Send updated metrics data to the dashboard service"
    task generate: :environment do
      MetricsService.call
    end
  end
end
