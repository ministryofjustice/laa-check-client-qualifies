class InstantSessionsController < ApplicationController
  def create
    # Workaround: The session cookie string is not finalised until AFTER the first ever render/redirect is finalised.
    # However by that point we've already USED the session cookie string below to construct the assessment ID.
    # This means that if this endpoint is the first thing that's visited in a session, we'll stash some stuff in the session
    # but then the session cookie string will change so we won't be able to retrieve what we've stashed later.
    # To get around this, we force at least one redirect here to guarantee a stable session cookie string
    return redirect_to instant_session_path(session_type: params[:session_type], redirected: true) unless params[:redirected]

    data = if FeatureFlags.enabled?(:conditional_reveals, without_session_data: true)
             case params[:session_type]
             when "controlled"
               FactoryBot.build(:instant_controlled_session)
             when "controlled-scenario"
               FactoryBot.build(:rich_instant_controlled_session)
             when "certificated"
               FactoryBot.build(:instant_certificated_session)
             else
               return render file: "public/404.html", layout: false
             end
           else
             case params[:session_type]
             when "controlled"
               FactoryBot.build(:instant_controlled_session_without_conditional_reveals)
             when "controlled-scenario"
               FactoryBot.build(:rich_instant_controlled_session_without_conditional_reveals)
             when "certificated"
               FactoryBot.build(:instant_certificated_session_without_conditional_reveals)
             else
               return render file: "public/404.html", layout: false
             end
           end

    session[assessment_id] = data.merge("feature_flags" => FeatureFlags.session_flags)
    redirect_to check_answers_path assessment_code:
  end

  def assessment_code
    @assessment_code ||= SecureRandom.uuid
  end
end
