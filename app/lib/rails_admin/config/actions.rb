module RailsAdmin
  module Config
    module Actions
      class IssueAction < RailsAdmin::Config::Actions::Base
        register_instance_option(:only) { Issue }
        register_instance_option(:http_methods) { %i[get post] }
        register_instance_option(:pjax?) { false }

        def self.set_controller_instance_variables
          proc do
            @model_name = to_model_name("issue")
            @abstract_model = RailsAdmin::AbstractModel.new(@model_name)
            @model_config = @abstract_model.config
            @properties = @abstract_model.properties
          end
        end
      end

      class PublishIssue < IssueAction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option(:link_icon) { "fa fa-circle-exclamation" }
        register_instance_option(:root) { true }
        register_instance_option :controller do
          proc do
            @object = Issue.new
            next render :publish_issue unless request.post?

            instance_eval(&RailsAdmin::Config::Actions::IssueAction.set_controller_instance_variables)

            outcome = IssueService.publish(params)
            @object = outcome.model
            if outcome.success?
              redirect_to RailsAdmin.railtie_routes_url_helpers.index_path(model_name: "issue"), flash: { notice: I18n.t("admin.actions.publish_issue.issue_published") }
            else
              handle_save_error(:publish_issue)
            end
          end
        end
      end

      class UpdateIssue < IssueAction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option(:link_icon) { "fa fa-pen-nib" }
        register_instance_option(:member) { true }
        register_instance_option :controller do
          proc do
            @object = IssueUpdate.new(issue_id: params[:id])
            next render :update_issue unless request.post?

            instance_eval(&RailsAdmin::Config::Actions::IssueAction.set_controller_instance_variables)

            outcome = IssueService.update(params)
            @object = outcome.model
            if outcome.success?
              redirect_to RailsAdmin.railtie_routes_url_helpers.index_path(model_name: "issue"), flash: { notice: I18n.t("admin.actions.update_issue.issue_updated") }
            else
              handle_save_error(:update_issue)
            end
          end
        end
      end

      class ResolveIssue < IssueAction
        RailsAdmin::Config::Actions.register(self)
        register_instance_option(:link_icon) { "fa fa-check" }
        register_instance_option(:member) { true }
        register_instance_option :controller do
          proc do
            @object = IssueUpdate.new(issue_id: params[:id])
            next render :resolve_issue unless request.post?

            instance_eval(&RailsAdmin::Config::Actions::IssueAction.set_controller_instance_variables)

            outcome = IssueService.resolve(params)
            @object = outcome.model
            if outcome.success?
              redirect_to RailsAdmin.railtie_routes_url_helpers.index_path(model_name: "issue"), flash: { notice: I18n.t("admin.actions.resolve_issue.issue_resolved") }
            else
              handle_save_error(:resolve_issue)
            end
          end
        end
      end
    end
  end
end
