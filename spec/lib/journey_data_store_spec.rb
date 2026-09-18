RSpec.describe JourneyDataStore do
  describe JourneyDataStore::SessionStore do
    let(:session) { {} }
    let(:assessment_id) { "test_assessment_id" }
    let(:store) { described_class.new(session, assessment_id) }

    describe "#read" do
      context "when data exists for the assessment_id" do
        before { session[assessment_id] = { "key" => "value" } }

        it "returns the data" do
          expect(store.read).to eq({ "key" => "value" })
        end
      end

      context "when no data exists for the assessment_id" do
        it "raises KeyNotFound error" do
          expect { store.read }.to raise_error(JourneyDataStore::KeyNotFound)
        end
      end
    end

    describe "#write" do
      it "stores the data in the session under the assessment_id key" do
        store.write({ "foo" => "bar" })
        expect(session[assessment_id]).to eq({ "foo" => "bar" })
      end
    end

    describe "#init" do
      context "when no data exists for the assessment_id" do
        it "initializes the session with the provided data" do
          store.init({ "initial_key" => "initial_value" })
          expect(session[assessment_id]).to eq({ "initial_key" => "initial_value" })
        end
      end

      context "when data already exists for the assessment_id" do
        before { session[assessment_id] = { "existing_key" => "existing_value" } }

        it "does not overwrite existing data" do
          store.init({ "new_key" => "new_value" })
          expect(session[assessment_id]).to eq({ "existing_key" => "existing_value" })
        end
      end
    end

    describe "#delete" do
      it "deletes the data from the session for the assessment_id" do
        session[assessment_id] = { "key" => "value" }
        store.delete
        expect(session[assessment_id]).to be_nil
      end

      it "does not raise an error if no data exists for the assessment_id" do
        expect { store.delete }.not_to raise_error
      end
    end
  end

  describe JourneyDataStore::RedisStore do
    let(:resource_id) { "test_resource_id" }
    let(:session_id) { "test_session_cookie" }
    let(:store) { described_class.new(resource_id, session_id) }

    describe "#read" do
      context "when data exists for the resource_id and session cookie" do
        before { Rails.cache.write(store.send(:cache_key), { "key" => "value" }) }

        it "returns the data" do
          expect(store.read).to eq({ "key" => "value" })
        end
      end

      context "when another session has data for the same resource_id" do
        before do
          Rails.cache.write(described_class.new(resource_id, "another_session_cookie").send(:cache_key), { "key" => "value" })
        end

        it "raises KeyNotFound error" do
          expect { store.read }.to raise_error(JourneyDataStore::KeyNotFound)
        end
      end

      context "when no data exists for the resource_id and session cookie" do
        let(:store) { described_class.new("non_existent_resource_id", session_id) }

        it "raises KeyNotFound error" do
          expect { store.read }.to raise_error(JourneyDataStore::KeyNotFound)
        end
      end
    end

    describe "#write" do
      it "stores the data in the cache under the resource and session key" do
        store.write({ "foo" => "bar" })
        expect(Rails.cache.read(store.send(:cache_key))).to eq({ "foo" => "bar" })
      end

      it "uses a 12-hour expiry" do
        expect(Rails.cache).to receive(:write).with(
          store.send(:cache_key),
          { "foo" => "bar" },
          expires_in: 12.hours,
        )

        store.write({ "foo" => "bar" })
      end
    end

    describe "#init" do
      context "when no data exists for the resource_id and session cookie" do
        it "initializes the cache with the provided data" do
          store.init({ "initial_key" => "initial_value" })
          expect(Rails.cache.read(store.send(:cache_key))).to eq({ "initial_key" => "initial_value" })
        end
      end

      context "when data already exists for the resource_id and session cookie" do
        before { Rails.cache.write(store.send(:cache_key), { "existing_key" => "existing_value" }) }

        it "does not overwrite existing data with the new data" do
          store.init({ "new_key" => "new_value" })
          expect(Rails.cache.read(store.send(:cache_key))).to eq({ "existing_key" => "existing_value" })
        end
      end
    end

    describe "#delete" do
      it "deletes the data from the cache for the resource and session key" do
        Rails.cache.write(store.send(:cache_key), { "key" => "value" })
        store.delete
        expect(Rails.cache.read(store.send(:cache_key))).to be_nil
      end

      it "does not delete another session's data for the same resource_id" do
        another_store = described_class.new(resource_id, "another_session_cookie")
        another_store.write({ "key" => "other value" })

        store.delete

        expect(another_store.read).to eq({ "key" => "other value" })
      end

      it "does not raise an error if no data exists for the resource_id" do
        expect { store.delete }.not_to raise_error
      end
    end

    describe "#cache_key" do
      let(:long_session_cookie) { "session-cookie" * 1000 }
      let(:long_cookie_store) { described_class.new(resource_id, long_session_cookie) }

      it "is deterministic and bounded for long session cookies" do
        expect(long_cookie_store.send(:cache_key)).to eq(
          described_class.new(resource_id, long_session_cookie).send(:cache_key),
        )
        expect(long_cookie_store.send(:cache_key).bytesize).to be <= 250
      end

      it "differs for different session cookies" do
        expect(long_cookie_store.send(:cache_key)).not_to eq(
          described_class.new(resource_id, "another-session-cookie").send(:cache_key),
        )
      end

      it "differs for different resource ids" do
        expect(store.send(:cache_key)).not_to eq(
          described_class.new("another_resource_id", session_id).send(:cache_key),
        )
      end
    end

    describe "when the session cookie is blank" do
      let(:blank_store) { described_class.new(resource_id, " ") }

      before do
        allow(Rails.cache).to receive(:read)
        allow(Rails.cache).to receive(:write)
        allow(Rails.cache).to receive(:exist?)
        allow(Rails.cache).to receive(:delete)
      end

      it "raises KeyNotFound without touching the cache" do
        expect { blank_store.read }.to raise_error(JourneyDataStore::KeyNotFound)
        expect { blank_store.write({ "key" => "value" }) }.to raise_error(JourneyDataStore::KeyNotFound)
        expect { blank_store.init({ "key" => "value" }) }.to raise_error(JourneyDataStore::KeyNotFound)
        expect { blank_store.delete }.to raise_error(JourneyDataStore::KeyNotFound)

        expect(Rails.cache).not_to have_received(:read)
        expect(Rails.cache).not_to have_received(:write)
        expect(Rails.cache).not_to have_received(:exist?)
        expect(Rails.cache).not_to have_received(:delete)
      end
    end
  end
end
