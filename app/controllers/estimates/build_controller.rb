class Estimates::BuildController < ApplicationController
  include Wicked::Wizard
  include PagesHelper

  steps(*ALL_PAGE_STEPS)

  def new
    session[session_key] = {}
    redirect_to wizard_path(steps.first)
  end

  def show
    @page = DummyForm.new session[session_key]
    render_wizard
  end

  def update
    if step == :intro
      @page = DummyForm.new(intro_params)
      if @page.valid?
        session[session_key] = @page.attributes
        redirect_to wizard_path next_step_for(@page, step)
      else
        render_wizard
      end
    else
      session.remove(session_key)
      redirect_to next_wizard_path
    end
  end

  private

  def session_key
    "dummy_form_#{params[:estimate_id]}"
  end

  def intro_params
    params.require(:dummy_form).permit(:passporting, :over_60, :dependants, :partner, :employed)
  end
end
