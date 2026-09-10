require "rails_helper"

RSpec.describe "checks/check_answers.html.slim", ccq_mode: :embedded do
  let(:resource_id) { "test_resource_id" }
  let(:session_data) { build(:minimal_complete_session, passporting: true) }
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
end
