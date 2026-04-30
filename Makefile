.PHONY: test-prepare test-all test test-embedded

test-prepare:
	RAILS_ENV=test bundle exec rake parallel:prepare

test-all:
	bundle exec parallel_rspec spec -n 10

test:
	bundle exec rspec

# rails_helper.rb:51
test-embedded:
	CCQ_MODE=embedded bundle exec rspec