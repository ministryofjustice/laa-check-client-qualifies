namespace :db do
  namespace :migrations do
    desc "Run db:migrate and retry if ActiveRecord::ConcurrentMigrationError encountered"
    task run_with_retry: :environment do
      attempts = 0
      begin
        Rake::Task["db:migrate"].reenable
        Rake::Task["db:migrate"].invoke
      rescue ActiveRecord::ConcurrentMigrationError
        attempts += 1
        if attempts <= 3
          sleep(5)
          retry
        else
          raise
        end
      end
    end
  end
end
