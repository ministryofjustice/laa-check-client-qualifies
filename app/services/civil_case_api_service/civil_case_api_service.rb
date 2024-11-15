class CivilCaseApiService
  require 'net/http'
  require 'uri'
  require 'json'

  BASE_URL = "https://laa-civil-case-api.example.com"

  def self.fetch_session_data(assessment_id)
    uri = URI.parse("#{BASE_URL}/cases/#{assessment_id}/session_data")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Get.new(uri.request_uri)
    # Add authentication headers if required
    # request["Authorization"] = "Bearer #{your_token}"
    response = http.request(request)
    JSON.parse(response.body)["session_data"]
  end

  def self.save_session_data(assessment_id, session_data)
    uri = URI.parse("#{BASE_URL}/cases/#{assessment_id}/session_data")
    http = Net::HTTP.new(uri.host, uri.port)
    http.use_ssl = true
    request = Net::HTTP::Post.new(uri.path, { 'Content-Type' => 'application/json' })
    # Add authentication headers if required
    # request["Authorization"] = "Bearer #{your_token}"
    request.body = { session_data: session_data }.to_json
    response = http.request(request)
    # Handle the response if needed
  end
end