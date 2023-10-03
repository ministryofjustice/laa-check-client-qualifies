class FeedbacksController < ApplicationController
  def new; end

  def create
    # will the data always look like this? could satisfaction_feedback be an empty hash?

    @form = params[:feedback_type].include?("satisfaction") ? satisfaction_model : freetext_model

    if @form.valid?
      if params.include?(:satisfaction_feedback)
        SatisfactionFeedback.create!(
          satisfied:,
          level_of_help:,
          outcome:,
        )
      else
        FreetextFeedback.create!(
          text:,
          page:,
          level_of_help:,
        )
      end
    else
      track_validation_error
    end
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def satisfaction_model
    SatisfactionFeedback.new(params.require[:feedback].permit(:satisfied))
  end

  def freetext_model
    FreetextFeedback.new(params.require[:feedback].permit(:text, :page))
  end

  def satisfied
    @form.satisfied
  end

  def text
    @form.text
  end

  def page
    # how to get the page? we use a combination of controller and action in other places
    # can we use the steps logic?
    step
  end

  def level_of_help
    session_data["level_of_help"]
  end

  def outcome
    session_data["api_response"].dig(:result_summary, :overall_result)[:result]
  end

  def step
    @step ||= Flow::Handler.step_from_url_fragment(params[:step_url_fragment])
  end
end
