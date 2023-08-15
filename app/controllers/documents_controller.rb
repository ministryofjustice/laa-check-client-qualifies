class DocumentsController < ApplicationController
  def show
    @document_path = download_document_path(params[:id])
    @page_number = GuidanceLinkService.call(document: params[:id], sub_section: params[:sub_section], page_number_only: true)
    render :show, layout: false
  end

  def download
    url = GuidanceLinkService.call(document: params[:id], original_link: true)
    http_conn = Faraday.new do |faraday|
      faraday.response :follow_redirects
      faraday.adapter Faraday.default_adapter
    end
    response = http_conn.get url
    Tempfile.open(url) do |file|
      file.write(response.body.force_encoding("UTF-8"))
      file.rewind
      send_file file, filename: url.split("/").last, type: "application/pdf"
    end
  end
end
