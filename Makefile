.PHONY: watch

# The command to run the watcher
watch:
	RAILS_ENV=test bundle exec rake rspec_watcher:watch