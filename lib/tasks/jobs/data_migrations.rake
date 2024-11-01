namespace :db do
  namespace :data_migrations do
    desc "Populate early_eligibility_result in completed_user_journeys"
    task populate_early_eligibility_result: :environment do
      # Update checks where "early_eligibility_selection" is "gross"
      records_to_set_true = CompletedUserJourney.where("session ->> 'early_eligibility_selection' = ?", "gross")
      count_true = records_to_set_true.update_all(early_eligibility_result: true)

      # Update checks where "early_eligibility_selection" is NOT "gross" or missing
      records_to_set_false = CompletedUserJourney.where(
        "session ->> 'early_eligibility_selection' != ? OR (session ->> 'early_eligibility_selection') IS NULL",
        "gross",
      )
      count_false = records_to_set_false.update_all(early_eligibility_result: false)

      total_updated = count_true + count_false

      puts "Data migration completed successfully."
      puts "Total records updated: #{total_updated}"
      puts "Records set to true: #{count_true}"
      puts "Records set to false: #{count_false}"
    rescue StandardError => e
      puts "An error occurred during data migration: #{e.class} - #{e.message}"
    end
  end
end
