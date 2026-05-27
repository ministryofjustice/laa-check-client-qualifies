.PHONY: build test-prepare test-all test test-embedded check

build:
	docker build --platform linux/amd64 -t laa-check-client-qualifies:latest .

test-prepare:
	RAILS_ENV=test bundle exec rake parallel:prepare

test-all:
	COLLATE_COVERAGE=true CCQ_MODE=standalone bundle exec parallel_rspec && \
	COLLATE_COVERAGE=true CCQ_MODE=embedded bundle exec parallel_rspec && \
	bundle exec ruby bin/collate_coverage

test:
	bundle exec rspec

test-embedded:
	CCQ_MODE=embedded bundle exec rspec

zeitwerk-check:
	DISABLE_SPRING=1 DISABLE_BOOTSNAP=1 CI=true bundle exec rake zeitwerk:check