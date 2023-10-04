class FeedbacksController < ApplicationController
  def create
    # will the data always look like this?
    @form = params[:type]&.include?("satisfaction") ? satisfaction_model : freetext_model
    if @form.valid?
      if params[:type].include?("satisfaction")
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
    SatisfactionFeedback.new(params.permit(:satisfied))
  end

  def freetext_model
    FreetextFeedback.new(params.permit(:text, :page))
  end

  def satisfied
    @form.satisfied
  end

  def text
    @form.text
  end

  def page
    # can the page always be sent down from the view? check answers might be different
    @form.page
  end

  def level_of_help
    session_data["level_of_help"]
  end

  def outcome
    session_data["api_response"].dig(:result_summary, :overall_result)[:result]
  end
end
