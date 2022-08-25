class BuildEstimatesController < ApplicationController
  include Wicked::Wizard
  include BuildEstimatesHelper

  steps(*ALL_ESTIMATE_STEPS)

  MONTHLY_INCOME_ATTRIBUTES = MonthlyIncomeForm::INCOME_ATTRIBUTES + [:monthly_incomes]

  def new
    session[session_key] = {}
    redirect_to wizard_path(steps.first)
  end

  def show
    case step
    when :intro
      @estimate = IntroForm.new session[session_key]
    when :monthly_income
      @estimate = MonthlyIncomeForm.new session[session_key].slice(*MONTHLY_INCOME_ATTRIBUTES)
    when :property
      @intro_form = IntroForm.new session[session_key]
    end
    render_wizard
  end

  def update
    case step
    when :intro
      @estimate = IntroForm.new(intro_params)
      if @estimate.valid?
        session[session_key] = @estimate.attributes
        redirect_to wizard_path next_step_for(@estimate, step)
      else
        render_wizard
      end
    when :monthly_income
      @estimate = MonthlyIncomeForm.new(monthly_income_params)
      if @estimate.valid?
        session[session_key].merge(@estimate.attributes)
        redirect_to next_wizard_path
      else
        render_wizard
      end
    else
      session.delete(session_key)
      redirect_to next_wizard_path
    end
  end

  private

  def session_key
    "estimate_#{params[:estimate_id]}"
  end

  def intro_params
    params.require(:intro_form).permit(*IntroForm::INTRO_ATTRIBUTES)
  end

  def monthly_income_params
    # params.require(:monthly_income_form).permit(*MonthlyIncomeForm::INCOME_ATTRIBUTES, monthly_incomes: [])
    params.require(:monthly_income_form).permit(:employment_income, :friends_or_family, monthly_incomes: [])
  end
end
