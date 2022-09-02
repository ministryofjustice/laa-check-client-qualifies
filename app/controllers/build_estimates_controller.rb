class BuildEstimatesController < ApplicationController
  include Wicked::Wizard
  include StepsHelper

  steps(*ALL_STEPS)

  MONTHLY_INCOME_ATTRIBUTES = (MonthlyIncomeForm::INCOME_ATTRIBUTES + [:monthly_incomes]).freeze
  PROPERTY_ATTRIBUTES = [:property_owned].freeze
  VEHICLE_ATTRIBUTES = [:vehicle_owned].freeze
  ASSETS_ATTRIBUTES = (AssetsForm::ASSETS_ATTRIBUTES + [:assets]).freeze

  def show
    case step
    when :intro
      @estimate = load_intro_form
    when :monthly_income
      @estimate = MonthlyIncomeForm.new session_data.slice(*MONTHLY_INCOME_ATTRIBUTES)
    when :client_property
      @intro_form = load_intro_form
      @estimate = load_property_form
    when :client_vehicle
      @estimate = VehicleForm.new session_data.slice(*VEHICLE_ATTRIBUTES)
    when :assets
      @estimate = AssetsForm.new session_data.slice(*ASSETS_ATTRIBUTES)
    when :summary
      @estimate = load_intro_form
    when :results
      @estimate = api_result(estimate_id)
    end
    render_wizard
  end

  def update
    case step
    when :intro
      estimate = IntroForm.new(intro_params)
      next_step = next_step_for(estimate, nil, step)
    when :monthly_income
      estimate = MonthlyIncomeForm.new(monthly_income_params)
      next_step = nil
    when :client_property
      @intro_form = load_intro_form
      estimate = PropertyForm.new(client_property_params)
      next_step = next_step_for(@intro_form, estimate, step)
    when :client_vehicle
      estimate = VehicleForm.new(vehicle_params)
      next_step = nil
    when :assets
      estimate = AssetsForm.new(assets_params)
      next_step = nil
    else
      estimate = nil
      next_step = nil
    end

    if estimate.present?
      if estimate.valid?
        save_data(estimate)
        if next_step.present?
          redirect_to wizard_path next_step
        else
          redirect_to next_wizard_path
        end
      else
        @estimate = estimate
        render_wizard
      end
    else
      session.delete(session_key)
      redirect_to next_wizard_path
    end
  end

  private

  def save_data(estimate)
    case step
    when :intro
      save_intro_form(estimate)
    when :client_property
      save_property_form(estimate)
    else
      session_data.merge!(estimate.attributes)
    end
  end

  def load_intro_form
    IntroForm.new session_data.slice(*IntroForm::INTRO_ATTRIBUTES.map(&:to_s))
  end

  def save_intro_form intro_form
    applicant = {
      applicant: {
        date_of_birth: intro_form.over_60 ? 61.years.ago.to_date : 59.years.ago.to_date,
        has_partner_opponent: false,
        receives_qualifying_benefit: intro_form.passporting
      }
    }
    create_record(estimate_id, "applicant", applicant)
    session_data.merge!(intro_form.attributes)
  end

  def load_property_form
    PropertyForm.new session_data.slice(*PROPERTY_ATTRIBUTES)
  end

  def save_property_form estimate
    session_data.merge!(estimate.attributes)
  end

  def estimate_id
    params[:estimate_id]
  end

  def session_data
    session[session_key] ||= {}
  end

  def session_key
    "estimate_#{estimate_id}"
  end

  def intro_params
    params.require(:intro_form).permit(*IntroForm::INTRO_ATTRIBUTES)
  end

  def monthly_income_params
    params.require(:monthly_income_form).permit(:employment_income, :friends_or_family, monthly_incomes: [])
  end

  def client_property_params
    params.require(:property_form).permit(:property_owned)
  end

  def vehicle_params
    params.require(:vehicle_form).permit(:vehicle_owned)
  end

  def assets_params
    params.require(:assets_form).permit(:savings)
  end
end
