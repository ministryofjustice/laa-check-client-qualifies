class QuestionFlowController < ApplicationController
  before_action :load_check

  def show
    track_page_view
    if step == :ineligible_gross_income
      @previous_step = :other_income
      completed_steps = Steps::Helper.completed_steps_for(session_data, @previous_step)
      @gross_income_excess = CfeService.result(session_data, completed_steps).gross_income_excess
    else
      @previous_step = Steps::Helper.previous_step_for(@check, step)
    end
    @form = Flow::Handler.form_from_session(step, session_data)
    render "/question_flow/#{step}"
  end

protected

  def load_check
    @check = Check.new(session_data)
  end

  def assessment_code
    params[:assessment_code].presence
  end

  def page_name
    step
  end

  def track_choices(form)
    ChoiceAnalyticsService.call(form, assessment_code, cookies)
  end

  def step
    @step ||= Flow::Handler.step_from_url_fragment(params[:step_url_fragment])
  end

  def tag_from(step)
    return if Flow::Handler::STEPS.fetch(step)[:tag].nil?

    Flow::Handler::STEPS.fetch(step)[:tag]
  end

  def last_tag_in_group?(tag)
    remaining_steps = Steps::Helper.remaining_steps_for(@check, step)

    return if remaining_steps.blank?

    remaining_tags = []
    remaining_steps.map do |remaining|
      remaining_tags << tag_from(remaining)
    end
    return unless !remaining_tags.compact.include?(tag) && tag_from(step) == tag

    true
  end
end
