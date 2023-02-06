class BenefitsController < EstimateFlowController
  skip_before_action :setup_wizard, only: %i[edit update destroy]

  def new
    @model = model_class.new
    @estimate = load_estimate
    track_page_view(assessment_id: estimate_id)
  end

  def create
    @estimate = load_estimate
    @model = model_class.new(params.require(model_class.name.underscore).permit(*model_class::EDITABLE_ATTRIBUTES))
    if @model.valid?
      @model.id = SecureRandom.uuid
      session_data[benefit_session_key] ||= []
      session_data[benefit_session_key] << @model.attributes
      redirect_to flow_path(step_name)
    else
      track_validation_error(assessment_id: estimate_id)
      render :new
    end
  end

  def edit
    @estimate = load_estimate
    benefit_attributes = session_data[benefit_session_key].find { _1["id"] == params[:id] }
    @model = model_class.new(benefit_attributes)
    track_page_view(assessment_id: estimate_id)
  end

  def update
    @estimate = load_estimate
    benefit_attributes = session_data[benefit_session_key].find { _1["id"] == params[:id] }
    @model = model_class.new(benefit_attributes)
    @model.assign_attributes(params.require(model_class.name.underscore).permit(*model_class::EDITABLE_ATTRIBUTES))
    if @model.valid?
      index = session_data[benefit_session_key].index(benefit_attributes)
      session_data[benefit_session_key][index] = @model.attributes
      redirect_to flow_path(step_name)
    else
      track_validation_error(assessment_id: estimate_id)
      render :edit
    end
  end

  def destroy
    session_data[benefit_session_key].delete_if { _1["id"] == params["id"] }
    redirect_to post_destroy_path
  end

  def add
    @form = Flow::Handler.model_from_params(step_name, params, session_data)
    @estimate = load_estimate
    if @form.valid?
      if @form.add_benefit
        redirect_to new_path
      else
        session_data.merge!(@form.session_attributes)
        redirect_to next_step_path @estimate
      end
    else
      track_validation_error(assessment_id: estimate_id)
      render "estimate_flow/#{step_name}"
    end
  end

private

  def step_name
    :benefits
  end

  def benefit_session_key
    "benefits"
  end

  def model_class
    BenefitModel
  end

  def flow_path(step)
    estimate_build_estimate_path estimate_id, step
  end

  def new_path
    new_estimate_benefit_path(estimate_id)
  end

  def next_step_path(model)
    flow_path StepsHelper.next_step_for(model, step_name)
  end

  def post_destroy_path
    if session_data[benefit_session_key].any?
      flow_path(step_name)
    else
      new_path
    end
  end

  def page_name
    "#{action_name}_#{step_name}"
  end
end
