class DocumentsController < ApplicationController
  def show
    AnalyticsService.call(event_type: "click_link_to_#{params[:id]}",
                          page: params[:referrer],
                          assessment_code: params[:assessment_code],
                          cookies:)
    redirect_to GuidanceLinkService.call(document: params[:id], sub_section: params[:sub_section]), allow_other_host: true
  end
end
