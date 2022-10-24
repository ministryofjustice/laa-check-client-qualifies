class BenefitsController < EstimateFlowController
  skip_before_action :setup_wizard, only: %i[edit update destroy]

  def new
    @model = BenefitModel.new
  end

  def create
    @model = BenefitModel.new(params.require(:benefit_model).permit(*BenefitModel::EDITABLE_ATTRIBUTES))
    if @model.valid?
      @model.id = SecureRandom.uuid
      session_data["benefits"] ||= []
      session_data["benefits"] << @model.attributes
      redirect_to index_path
    else
      render :new
    end
  end

  def edit
    benefit_attributes = session_data["benefits"].find { _1["id"] == params[:id] }
    @model = BenefitModel.new(benefit_attributes)
    @model.return_to_check_answers = params[:check_answers]
  end

  def update
    benefit_attributes = session_data["benefits"].find { _1["id"] == params[:id] }
    @model = BenefitModel.new(benefit_attributes)
    @model.assign_attributes(params.require(:benefit_model).permit(*BenefitModel::EDITABLE_ATTRIBUTES))
    if @model.valid?
      index = session_data["benefits"].index(benefit_attributes)
      session_data["benefits"][index] = @model.attributes
      if @model.return_to_check_answers
        redirect_to estimate_build_estimate_path estimate_id, :check_answers
      else
        redirect_to index_path
      end
    else
      render :edit
    end
  end

  def destroy
    session_data["benefits"].delete_if { _1["id"] == params["id"] }
    if session_data["benefits"].any?
      redirect_to index_path
    else
      redirect_to new_estimate_benefit_path(params[:estimate_id])
    end
  end

  def add
    @form = Flow::BenefitsHandler.form(params, session_data)
    @estimate = load_estimate
    if @form.valid?
      if @form.add_benefit
        redirect_to new_estimate_benefit_path(estimate_id)
      else
        session_data[:add_benefit] = false
        redirect_to estimate_build_estimate_path(estimate_id, StepsHelper.next_step_for(@estimate, :benefits))
      end
    else
      render "estimate_flow/benefits"
    end
  end

private

  def index_path
    estimate_build_estimate_path estimate_id, :benefits
  end
end
