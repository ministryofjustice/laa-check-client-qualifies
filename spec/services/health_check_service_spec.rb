require "rails_helper"

RSpec.describe HealthCheckService do
  describe ".call" do
    context "when both database and cache are healthy" do
      it "returns true" do
        allow(described_class).to receive(:database_healthy?).and_return(true)
        allow(described_class).to receive(:short_term_persistence_healthy?).and_return(true)
        
        expect(described_class.call).to be(true)
      end
    end

    context "with real integration" do
      it "actually checks both database and cache health" do
        # This test exercises the real code paths
        result = described_class.call
        expect(result).to be(true)
      end
    end

    context "when database is unhealthy" do
      it "returns false" do
        allow(described_class).to receive(:database_healthy?).and_return(false)
        allow(described_class).to receive(:short_term_persistence_healthy?).and_return(true)
        
        expect(described_class.call).to be(false)
      end
    end

    context "when cache is unhealthy" do
      it "returns false" do
        allow(described_class).to receive(:database_healthy?).and_return(true)
        allow(described_class).to receive(:short_term_persistence_healthy?).and_return(false)
        
        expect(described_class.call).to be(false)
      end
    end

    context "when an exception is raised" do
      it "returns false" do
        allow(described_class).to receive(:database_healthy?).and_raise(StandardError, "Something went wrong")
        
        expect(described_class.call).to be(false)
      end
      
      it "handles exceptions from short_term_persistence_healthy?" do
        allow(described_class).to receive(:database_healthy?).and_return(true)
        allow(described_class).to receive(:short_term_persistence_healthy?).and_raise(StandardError, "Cache error")
        
        expect(described_class.call).to be(false)
      end
    end
  end

  describe ".database_healthy?" do
    context "when connection is active" do
      it "returns true" do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(true)
        
        expect(described_class.database_healthy?).to be(true)
      end
    end

    context "when connection is not active" do
      it "returns false" do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_return(false)
        
        expect(described_class.database_healthy?).to be(false)
      end
    end

    context "when PG::ConnectionBad is raised" do
      it "returns false" do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_raise(PG::ConnectionBad)
        
        expect(described_class.database_healthy?).to be(false)
      end
    end

    context "when PG::UndefinedTable is raised" do
      it "returns false" do
        allow(ActiveRecord::Base.connection).to receive(:active?).and_raise(PG::UndefinedTable, "Table not found")
        
        expect(described_class.database_healthy?).to be(false)
      end
    end
  end

  describe ".short_term_persistence_healthy?" do
    context "when cache write and read work correctly" do
      it "returns true" do
        allow(Rails.cache).to receive(:write).with("_health_check_", "ok", expires_in: 5.seconds).and_return(true)
        allow(Rails.cache).to receive(:read).with("_health_check_").and_return("ok")
        
        expect(described_class.short_term_persistence_healthy?).to be(true)
      end
    end

    context "with real cache integration" do
      it "actually writes to and reads from the cache" do
        # Clear any existing cache
        Rails.cache.clear rescue nil
        
        # Test the actual implementation
        result = described_class.short_term_persistence_healthy?
        expect(result).to be(true)
        
        # Verify the cache entry was created
        expect(Rails.cache.read("_health_check_")).to eq("ok")
      end
    end

    context "when cache write fails" do
      it "returns false" do
        allow(Rails.cache).to receive(:write).with("_health_check_", "ok", expires_in: 5.seconds).and_return(false)
        
        expect(described_class.short_term_persistence_healthy?).to be(false)
      end
    end

    context "when cache read returns wrong value" do
      it "returns false" do
        allow(Rails.cache).to receive(:write).with("_health_check_", "ok", expires_in: 5.seconds).and_return(true)
        allow(Rails.cache).to receive(:read).with("_health_check_").and_return("not ok")
        
        expect(described_class.short_term_persistence_healthy?).to be(false)
      end
    end

    context "when cache read returns nil" do
      it "returns false" do
        allow(Rails.cache).to receive(:write).with("_health_check_", "ok", expires_in: 5.seconds).and_return(true)
        allow(Rails.cache).to receive(:read).with("_health_check_").and_return(nil)
        
        expect(described_class.short_term_persistence_healthy?).to be(false)
      end
    end
  end
end