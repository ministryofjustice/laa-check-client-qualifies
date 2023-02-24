require "rails_helper"

RSpec.describe ErrorService do
  describe ".call" do
    let(:exception) { :exception }

    context "when sentry is enabled" do
      before { allow(FeatureFlags).to receive(:enabled?).with(:sentry).and_return(true) }

      it "passes the exception to Sentry" do
        expect(Sentry).to receive(:capture_exception).with(exception)

        described_class.call(exception)
      end
    end

    context "when sentry is not enabled" do
      before { allow(FeatureFlags).to receive(:enabled?).with(:sentry).and_return(false) }

      it "passes the exception to ExceptionNotifier" do
        notifier = instance_double("ExceptionNotifier::TemplatedNotifier")
        allow(ExceptionNotifier::TemplatedNotifier).to receive(:new).and_return(notifier)
        expect(notifier).to receive(:call).with(exception)
        described_class.call(exception)
      end
    end
  end
end
