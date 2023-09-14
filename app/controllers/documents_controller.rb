class DocumentsController < ApplicationController
  def show
    AnalyticsService.call(event_type: "click_#{params[:id]}#{"_#{params[:sub_section]}" if params[:sub_section].present?}",
                          page: params[:referrer],
                          assessment_code: params[:assessment_code],
                          cookies:)
    redirect_to ExternalLinkService.call(document: params[:id], sub_section: params[:sub_section]), allow_other_host: true
  end
end
