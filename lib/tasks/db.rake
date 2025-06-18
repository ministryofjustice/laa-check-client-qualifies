namespace :db do
  desc "Output anonymised DB as restore file"
  task export: :environment do
    command = "pg_dump postgres://${POSTGRES_USER}:${POSTGRES_PASSWORD}@${POSTGRES_HOST}:5432/${POSTGRES_DATABASE} > ./tmp/temp.sql"
    create_success = `#{command}`
    zip_success = `gzip -3 -f ./tmp/temp.sql`
    result_success = [create_success, zip_success].all?(&:empty?)
    puts result_success ? "Success" : "Error occurred"
  end
end
