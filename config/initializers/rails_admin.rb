RailsAdmin.config do |config|
  config.asset_source = :webpack
  config.main_app_name = "CCQ"
  ### Popular gems integration

  ## == Devise ==
  config.authenticate_with do
    warden.authenticate! scope: :admin
  end
  config.current_user_method(&:current_admin)

  ## == CancanCan ==
  # config.authorize_with :cancancan

  ## == Pundit ==
  # config.authorize_with :pundit

  ## == PaperTrail ==
  # config.audit_with :paper_trail, 'User', 'PaperTrail::Version' # PaperTrail >= 3.0.0

  ### More at https://github.com/railsadminteam/rails_admin/wiki/Base-configuration

  ## == Gravatar integration ==
  ## To disable Gravatar integration in Navigation Bar set to false
  # config.show_gravatar = true

  config.actions do
    dashboard                     # mandatory
    index                         # mandatory
    new
    export
    bulk_delete
    show
    edit
    delete
    show_in_app

    ## With an audit adapter, you can add:
    # history_index
    # history_show
  end

  config.model "FeatureFlagOverride" do
    object_label_method { :key }
  end

  config.model "Admin" do
    object_label_method { :email }
  end

  config.excluded_models.push("AnalyticsEvent", "CompletedUserJourney", "Blazer::Audit", "Blazer::Check", "Blazer::Dashboard", "Blazer::DashboardQuery", "Blazer::Query")
end
