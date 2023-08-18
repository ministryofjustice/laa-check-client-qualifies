class DocumentsController < ApplicationController
  before_action :track_page_view, only: :show

  def show
    @document_path = download_document_path(params[:id])
    unless GuidanceLinkService.call(document: params[:id], data_type: :pdf)
      return redirect_to GuidanceLinkService.call(document: params[:id], data_type: :original_link), allow_other_host: true
    end

    @title = I18n.t("documents.show.titles.#{params[:id]}")
    @page_number = GuidanceLinkService.call(document: params[:id], sub_section: params[:sub_section], data_type: :page_number)
    render :show, layout: false
  end

  def download
    url = GuidanceLinkService.call(document: params[:id], data_type: :original_link)
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

  def page_name
    section_suffix = "_#{params[:sub_section]}_section" if params[:sub_section].present?
    "document_#{params[:id]}#{section_suffix}"
  end
end
