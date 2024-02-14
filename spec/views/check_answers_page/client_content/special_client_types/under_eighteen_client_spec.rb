require "rails_helper"

RSpec.describe "checks/check_answers.html.slim" do
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    allow(view).to receive(:form_with)
    render template: "checks/check_answers"
  end

  describe "under eighteen clients" do
    let(:session_data) do
      build(:minimal_complete_session,
            level_of_help: "controlled",
            controlled_legal_representation: false,
            client_age: "under_18",
            aggregated_means: false,
            regular_income: false,
            under_eighteen_assets: false)
    end

    it "renders the correct content" do
      expect(page_text).to include("What age is your client?Under 18")
      expect(page_text).to include("Level of help your client needsWhat level of help does your client need?")
      expect(page_text).to include("What level of help does your client need?Civil controlled work or family mediationChange")
      expect(page_text).to include("Is the work controlled legal representation (CLR)?NoChange")
      expect(page_text).to include("Means tests for under 18sWill you aggregate your client's means with another person's means?NoChange")
      expect(page_text).to include("Does your client get regular income?NoChange")
      expect(page_text).to include("Does your client have assets worth £2,500 or more?NoChange")
    end
  end
end
