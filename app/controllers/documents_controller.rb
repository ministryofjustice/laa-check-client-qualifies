class DocumentsController < ApplicationController
  def show
    if params[:referrer].present?
      AnalyticsService.call(event_type: "click_#{params[:id]}#{"_#{params[:sub_section]}" if params[:sub_section].present?}",
                            page: params[:referrer],
                            assessment_code: params[:assessment_code],
                            cookies:)
    end
    redirect_to ExternalLinkService.call(document: params[:id], sub_section: params[:sub_section]), allow_other_host: true
  end
end
