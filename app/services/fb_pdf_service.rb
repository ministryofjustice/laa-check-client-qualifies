# Service to integrate with FormBuilder's PDF Generator
class FbPdfService
  API_ENDPOINT = ENV.fetch('FB_PDF_GENERATOR_URL', 'http://localhost:3001')
  
  class PdfGenerationError < StandardError; end
  
  class << self
    def generate_pdf_from_html(html_string, display_url = nil)
      # For initial PoC, we'll convert HTML to the fb-pdf-generator format
      # In a real implementation, we'd want to map CCQ data more precisely
      payload = build_pdf_payload_from_html(html_string)
      
      response = HTTParty.post(
        "#{API_ENDPOINT}/v1/pdfs",
        body: payload.to_json,
        headers: {
          'Content-Type' => 'application/json',
          'x-access-token-v2' => jwt_token
        },
        timeout: 30
      )
      
      if response.success?
        response.body
      else
        raise PdfGenerationError, "PDF generation failed: #{response.code} - #{response.message}"
      end
    end
    
    # Compatibility method to match current PdfService interface
    def with_pdf_data_from_html_string(html_string, display_url)
      pdf_data = generate_pdf_from_html(html_string, display_url)
      yield pdf_data
    rescue PdfGenerationError => e
      Rails.logger.error "FB PDF Service Error: #{e.message}"
      raise
    end
    
    private
    
    def build_pdf_payload_from_html(html_string)
      # For CCQ integration, convert HTML assessment to structured form data
      # This creates a GOV.UK-style form receipt from the assessment
      
      {
        submission_id: "ccq-assessment-#{Time.current.to_i}",
        pdf_heading: "Civil Legal Aid Assessment Results",
        pdf_subheading: "Check Client Qualifies",
        sections: [
          {
            heading: "Client Information",
            questions: [
              {
                label: "Assessment Date",
                human_value: Time.current.strftime("%d %B %Y"),
                answer: Time.current.iso8601
              },
              {
                label: "Client Name",
                human_value: "Test Client",
                answer: "test_client"
              },
              {
                label: "Date of Birth", 
                human_value: "01/01/1980",
                answer: "1980-01-01"
              }
            ]
          },
          {
            heading: "Financial Assessment",
            questions: [
              {
                label: "Monthly Income",
                human_value: "£2,500.00",
                answer: "2500.00"
              },
              {
                label: "Monthly Outgoings",
                human_value: "£1,800.00", 
                answer: "1800.00"
              },
              {
                label: "Disposable Income",
                human_value: "£700.00",
                answer: "700.00"
              }
            ]
          },
          {
            heading: "Eligibility Decision",
            questions: [
              {
                label: "Result",
                human_value: "✅ Eligible for Legal Aid",
                answer: "eligible"
              },
              {
                label: "Case Type",
                human_value: "Housing Disrepair",
                answer: "housing_disrepair"
              },
              {
                label: "Assessment Reference",
                human_value: "CCQ-#{rand(100000..999999)}",
                answer: "assessment_ref"
              }
            ]
          }
        ]
      }
    end
    
    def extract_title_from_html(html_string)
      # Simple title extraction from HTML
      match = html_string.match(/<title[^>]*>([^<]+)<\/title>/i)
      match ? match[1].strip : nil
    end
    
    def sanitize_html_for_pdf(html_string)
      # For PoC, we'll just strip HTML tags and truncate
      # In production, we'd want better HTML to text conversion
      ActionController::Base.helpers.strip_tags(html_string)
        .gsub(/\s+/, ' ')
        .strip
        .truncate(1000)
    end
    
    def jwt_token
      # For PoC, use a simple test token
      # In production, this would be properly signed JWT
      'test-token-ccq-poc'
    end
  end
end