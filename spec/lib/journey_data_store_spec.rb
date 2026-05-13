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
    let(:store) { described_class.new(resource_id) }

    describe "#read" do
      context "when data exists for the resource_id" do
        before { Rails.cache.write(resource_id, { "key" => "value" }) }

        it "returns the data" do
          expect(store.read).to eq({ "key" => "value" })
        end
      end

      context "when no data exists for the resource_id" do
        let(:store) { described_class.new("non_existent_resource_id") }

        it "raises KeyNotFound error" do
          expect { store.read }.to raise_error(JourneyDataStore::KeyNotFound)
        end
      end
    end

    describe "#write" do
      it "stores the data in the cache under the resource_id key" do
        store.write({ "foo" => "bar" })
        expect(Rails.cache.read(resource_id)).to eq({ "foo" => "bar" })
      end
    end

    describe "#init" do
      context "when no data exists for the resource_id" do
        it "initializes the cache with the provided data" do
          store.init({ "initial_key" => "initial_value" })
          expect(Rails.cache.read(resource_id)).to eq({ "initial_key" => "initial_value" })
        end
      end

      context "when data already exists for the resource_id" do
        before { Rails.cache.write(resource_id, { "existing_key" => "existing_value" }) }

        it "does not overwrite existing data with the new data" do
          store.init({ "new_key" => "new_value" })
          expect(Rails.cache.read(resource_id)).to eq({ "existing_key" => "existing_value" })
        end
      end
    end

    describe "#delete" do
      it "deletes the data from the cache for the resource_id" do
        Rails.cache.write(resource_id, { "key" => "value" })
        store.delete
        expect(Rails.cache.read(resource_id)).to be_nil
      end

      it "does not raise an error if no data exists for the resource_id" do
        expect { store.delete }.not_to raise_error
      end
    end
  end
end
