.PHONY: build test-prepare test-all test test-embedded test-ci-coverage check

build:
	docker build --platform linux/amd64 -t laa-check-client-qualifies:latest .

test-prepare:
	RAILS_ENV=test bundle exec rake parallel:prepare

test-all:
	COLLATE_COVERAGE=true CCQ_MODE=standalone bundle exec parallel_rspec && \
	COLLATE_COVERAGE=true CCQ_MODE=embedded bundle exec parallel_rspec && \
	bundle exec ruby bin/collate_coverage

test-ci-coverage:
	rm -rf coverage tmp/coverage_resultsets
	mkdir -p tmp/coverage_resultsets
	COVERAGE=true CCQ_MODE=standalone PARALLEL_TEST_PROCESSORS=5 bundle exec parallel_rspec
	cp coverage/.resultset.json tmp/coverage_resultsets/standalone.resultset.json
	rm -rf coverage
	COVERAGE=true CCQ_MODE=embedded DISABLE_BOOTSNAP=1 PARALLEL_TEST_PROCESSORS=3 bundle exec parallel_rspec
	cp coverage/.resultset.json tmp/coverage_resultsets/embedded.resultset.json
	mkdir -p coverage
	ruby -rjson -e 'files = Dir["tmp/coverage_resultsets/*.resultset.json"]; merged = files.sort.each_with_object({}) { |file, memo| memo.merge!(JSON.parse(File.read(file))) }; File.write("coverage/.resultset.json", JSON.generate(merged))'
	bundle exec ruby bin/collate_coverage

test:
	bundle exec rspec

test-embedded:
	CCQ_MODE=embedded bundle exec rspec

zeitwerk-check:
	DISABLE_SPRING=1 DISABLE_BOOTSNAP=1 CI=true bundle exec rake zeitwerk:check