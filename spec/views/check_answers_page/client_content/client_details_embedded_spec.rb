require "rails_helper"

RSpec.describe "checks/check_answers.html.slim", :embedded_only, ccq_mode: :embedded do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) do
    build(:minimal_complete_session,
          passporting: true,
          level_of_help: "controlled",
          immigration_or_asylum: false)
  end
  let(:sections) { CheckAnswers::SectionListerService.call(session_data) }

  before do
    assign(:sections, sections)
    assign(:previous_step, Steps::Helper.last_step(session_data))
    params[:assessment_code] = :code
    params[:resource_id] = resource_id
    allow(view).to receive(:form_with)
    allow(view).to receive_messages(
      step_path: "/embedded/step",
      check_step_path: "/embedded/change",
      result_path: "/embedded/result",
    )
    render template: "checks/check_answers"
  end

  it "shows client age without a change link" do
    fragment = Nokogiri::HTML.fragment(rendered)

    expect(page_text).to include("What age is your client?18 to 59")
    expect(fragment).not_to have_css('a.change-link[aria-label="Change Client age"]')
  end

  it "shows prefilled case details without change links" do
    fragment = Nokogiri::HTML.fragment(rendered)

    expect(page_text).to include("What level of help does your client need?Civil controlled work or family mediation")
    expect(page_text).to include("Is this an immigration or asylum matter?No")
    expect(fragment).not_to have_css('a.change-link[aria-label="Change Level of help your client needs"]')
    expect(fragment).not_to have_css('a.inline-change-link[aria-label="Change Level of help your client needs"]')
    expect(fragment).not_to have_css('a.change-link[aria-label="Change Matter type"]')
    expect(fragment).not_to have_css('a.inline-change-link[aria-label="Change Matter type"]')
    expect(fragment).to have_css('a.change-link[aria-label="Change Partner and passporting"]')
  end

  context "when the client is under 18" do
    let(:session_data) do
      build(:minimal_complete_session,
            passporting: true,
            level_of_help: "controlled",
            immigration_or_asylum: false,
            client_age: "under_18",
            controlled_legal_representation: false,
            aggregated_means: false,
            regular_income: false,
            under_eighteen_assets: false)
    end

    it "keeps the under-18 CLR answer editable" do
      fragment = Nokogiri::HTML.fragment(rendered)

      expect(page_text).to include("Is the work controlled legal representation (CLR)?No")
      expect(fragment).to have_css('a.inline-change-link[aria-label="Change controlled legal representation"]')
    end
  end
end
