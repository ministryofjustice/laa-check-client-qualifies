class FeedbacksController < ApplicationController
  FEEDBACK_TYPES = %w[freetext satisfaction].freeze

  def create
    unless FEEDBACK_TYPES.include?(params[:type])
      raise "Feedback type needs to be specified"
    end

    if params[:type] == "satisfaction"
      model = SatisfactionFeedback.create!(
        satisfied: params[:satisfied],
        level_of_help:,
        outcome:,
      )
      session[:most_recent_feedback_id] = model.id
      render json: { id: model.id }, status: :created
    else
      FreetextFeedback.create!(
        text: params[:freetext_input],
        page: params[:page],
        level_of_help:,
      )
      head :created
    end
  end

  def update
    return head(:forbidden) unless params[:id] == session[:most_recent_feedback_id].to_s

    SatisfactionFeedback.update!(
      comment: params[:comment],
    )

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
