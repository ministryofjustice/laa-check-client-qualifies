class DocumentsController < ApplicationController
  def show
    redirect_url = ExternalLinkService.call(document: params[:id], sub_section: params[:sub_section])
    
    # Return 404 for invalid document IDs (e.g., bot probes like wp.php, admin.php)
    return head :not_found if redirect_url.nil?

    if params[:referrer].present?
      AnalyticsService.call(event_type: "click_#{params[:id]}#{"_#{params[:sub_section]}" if params[:sub_section].present?}",
                            page: params[:referrer],
                            assessment_code: params[:assessment_code],
                            cookies:)
    end
    redirect_to redirect_url, allow_other_host: true
  rescue KeyError
    # Return 404 for invalid subsections
    head :not_found
  end
end
