class CivilCaseApiService
  require "net/http"
  require "uri"
  require "json"

  BASE_URL = "https://www.staging.civil-case-api.cloud-platform.service.justice.gov.uk".freeze

  def self.get_token
    uri = URI.parse("#{BASE_URL}/token")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/x-www-form-urlencoded", "accept" => "application/json" })
    request.set_form_data({
      "grant_type" => "password",
      "username" => ENV["CIVIL_CASE_API_USERNAME"],
      "password" => ENV["CIVIL_CASE_API_PASSWORD"],
      "scope" => "",
      "client_id" => ENV["CIVIL_CASE_API_CLIENT_ID"],
      "client_secret" => ENV["CIVIL_CASE_API_CLIENT_SECRET"],
    })
    response = http.request(request)
    JSON.parse(response.body)["access_token"]
  end

  def self.fetch_session_data(assessment_id)
    token = get_token
    uri = URI.parse("#{BASE_URL}/cases/#{assessment_id}/session_data")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    request["Authorization"] = "Bearer #{token}"
    response = http.request(request)
    JSON.parse(response.body)["session_data"]
  end

  def self.save_session_data(assessment_id, session_data)
    token = get_token
    uri = URI.parse("#{BASE_URL}/cases/#{assessment_id}/session_data")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, { "Content-Type" => "application/json" })
    request["Authorization"] = "Bearer #{token}"
    request.body = { session_data: session_data }.to_json
    http.request(request)
  end
end