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
      user_satisfaction_feedback_ids << model.id
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
    return head(:forbidden) unless user_satisfaction_feedback_ids.include?(params[:id].to_i)

    SatisfactionFeedback.find(params[:id]).update!(
      comment: params[:comment],
    )

    head :created
  end

private

  def user_satisfaction_feedback_ids
    session[:satisfaction_feedback_ids] ||= []
  end

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
