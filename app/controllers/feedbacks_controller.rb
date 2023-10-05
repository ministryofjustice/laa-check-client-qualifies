class FeedbacksController < ApplicationController
  FEEDBACK_TYPES = %w[freetext satisfaction].freeze

  def create
    if params[:type].nil? || !FEEDBACK_TYPES.include?(params[:type])
      raise "Feedback type needs to be specified"
    end

    @form = params[:type].include?("satisfaction") ? satisfaction_model : freetext_model
    if @form.valid?
      if @form.instance_of?(SatisfactionFeedback)
        SatisfactionFeedback.create!(
          satisfied: @form.satisfied,
          level_of_help:,
          outcome:,
        )
      else
        FreetextFeedback.create!(
          text: @form.text,
          page: @form.page,
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

  def level_of_help
    session_data["level_of_help"]
  end

  def outcome
    session_data["api_response"].dig("result_summary", "overall_result")["result"]
  end
end
