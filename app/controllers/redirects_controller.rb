class RedirectsController < ApplicationController
  def build_estimate
    redirect_to helpers.step_path_from_step(params[:step].to_sym, params[:assessment_code])
  end

  def check_answers
    redirect_to helpers.check_step_path_from_step(params[:step].to_sym, params[:assessment_code])
  end

  def result
    redirect_to result_path(assessment_code: params[:assessment_code])
  end

  def cw_forms
    redirect_to controlled_work_document_selection_path(assessment_code: params[:assessment_code])
  end
end
