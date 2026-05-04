.PHONY: build test-prepare test-all test test-embedded check

build:
	docker build -t laa-check-client-qualifies:latest .

test-prepare:
	RAILS_ENV=test bundle exec rake parallel:prepare

test-all:
	bundle exec parallel_rspec spec -n 10

test:
	bundle exec rspec

test-embedded:
	CCQ_MODE=embedded bundle exec rspec

zeitwerk-check:
	DISABLE_SPRING=1 DISABLE_BOOTSNAP=1 CI=true bundle exec rake zeitwerk:check