class FeedbacksController < ApplicationController
  FEEDBACK_TYPES = %w[freetext satisfaction].freeze

  def create
    unless FEEDBACK_TYPES.include?(params[:type])
      raise "Feedback type needs to be specified"
    end

    if params[:type] == "satisfaction"
      SatisfactionFeedback.create!(
        satisfied: params[:satisfied],
        level_of_help:,
        outcome:,
      )
    else
      FreetextFeedback.create!(
        text: params[:freetext_input],
        page: params[:page],
        level_of_help:,
      )
    end
    head :created
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def level_of_help
    return if assessment_code.blank?

    session_data["level_of_help"]
  end

  def outcome
    session_data.dig("api_response", "result_summary", "overall_result", "result")
  end
end
