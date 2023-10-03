class FeedbacksController < ApplicationController
  def new; end

  def create
    @form = params[:widget_type].include?("satisfaction") ? satisfaction_model : freetext_model

    if @form.valid?
      if params[:widget_type].include?("satisfaction")
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

  def satisfaction_model
    SatisfactionFeedback.new(params.permit(:satisfied, :level_of_help, :outcome))
  end

  def freetext_model
    FreetextFeedback.new(params.permit(:text, :page, :level_of_help))
  end

  def satisfied
    @form.satisfied
  end

  def text
    @form.text
  end

  def page
    @form.page
  end

  def level_of_help
    @form.level_of_help if @form.level_of_help.present?
  end

  def outcome
    @form.outcome
  end
end
