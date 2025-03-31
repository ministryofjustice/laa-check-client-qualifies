class ChecksController < ApplicationController
  before_action :redirect_to_primary_host, only: :new
  before_action :clear_early_result, only: :check_answers
  before_action :specify_satisfaction_feedback_page_name

  def new
    new_assessment_code = SecureRandom.uuid
    data = { "feature_flags" => FeatureFlags.session_flags }
    session[assessment_id(new_assessment_code)] = data
    redirect_to helpers.step_path_from_step(Steps::Helper.first_step(data), new_assessment_code)
  end

  def check_answers
    @check = Check.new(session_data)
    @previous_step = if Steps::Logic.check_stops_at_gross_income?(session_data)
                       :ineligible_gross_income
                     else
                       Steps::Helper.last_step(session_data)
                     end
    @sections = CheckAnswers::SectionListerService.call(session_data)
    track_page_view(page: :check_answers)
  end

  def cannot_use_service_additional_properties
    @check = Check.new(session_data)
    @previous_step = :additional_property
  end

  def end_of_journey
    @model = CalculationResult.new(session_data)
    @check = Check.new(session_data)
    @form = ControlledWorkDocumentSelection.from_session(session_data)
    track_page_view(page: :end_of_journey)
  end

private

  def assessment_code
    params[:assessment_code]
  end

  def clear_early_result
    # not all checks have an early result e.g. passported clients, U18 etc
    session_data["early_result"]&.clear
  end

  def specify_feedback_widget
    @feedback = action_name == "end_of_journey" ? :satisfaction : :freetext
  end

  def specify_satisfaction_feedback_page_name
    @satisfaction_feedback_page_name = page_name
  end
end
