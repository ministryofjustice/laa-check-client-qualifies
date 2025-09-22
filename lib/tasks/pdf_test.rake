namespace :pdf do
  desc "Test FB PDF Generator integration with sample HTML"
  task test_fb_generator: :environment do
    puts "🔧 Testing FB PDF Generator Integration..."
    
    # Sample HTML content similar to what CCQ generates
    sample_html = <<~HTML
      <!DOCTYPE html>
      <html>
        <head>
          <title>Civil Legal Aid Assessment Results</title>
          <meta charset="utf-8">
        </head>
        <body>
          <h1>Civil Legal Aid Assessment Results</h1>
          
          <div class="assessment-summary">
            <h2>Client Information</h2>
            <p><strong>Name:</strong> Test Client</p>
            <p><strong>Date of Birth:</strong> 01/01/1980</p>
            <p><strong>Assessment Date:</strong> #{Date.current.strftime('%d %B %Y')}</p>
          </div>
          
          <div class="financial-assessment">
            <h2>Financial Assessment</h2>
            <p><strong>Monthly Income:</strong> £2,500.00</p>
            <p><strong>Monthly Outgoings:</strong> £1,800.00</p>
            <p><strong>Disposable Income:</strong> £700.00</p>
          </div>
          
          <div class="eligibility-result">
            <h2>Eligibility Result</h2>
            <p class="result-positive"><strong>✅ Eligible for Legal Aid</strong></p>
            <p>Based on the financial assessment, this client qualifies for civil legal aid.</p>
          </div>
          
          <div class="case-details">
            <h2>Case Information</h2>
            <p><strong>Case Type:</strong> Housing Disrepair</p>
            <p><strong>Assessment Code:</strong> TEST-2025-001</p>
            <p><strong>Reference:</strong> CCQ-#{rand(100000..999999)}</p>
          </div>
        </body>
      </html>
    HTML
    
    begin
      puts "📡 Checking if FB PDF Generator is running on #{ENV.fetch('FB_PDF_GENERATOR_URL', 'http://localhost:3001')}..."
      
      # Test health endpoint first
      health_response = HTTParty.get("#{ENV.fetch('FB_PDF_GENERATOR_URL', 'http://localhost:3001')}/health", timeout: 5)
      
      if health_response.success?
        puts "✅ FB PDF Generator is running and healthy"
      else
        puts "⚠️  FB PDF Generator health check returned: #{health_response.code}"
      end
      
    rescue => e
      puts "❌ Cannot connect to FB PDF Generator: #{e.message}"
      puts "💡 Make sure to start it with:"
      puts "   cd /Users/sandy.ryalls/repos/fb-pdf-generator"
      puts "   export SERVICE_TOKEN_CACHE_ROOT_URL=http://localhost:3002"
      puts "   bundle exec rails s -p 3001"
      exit 1
    end
    
    begin
      puts "🔄 Generating PDF using FB PDF Generator..."
      
      # Generate PDF using the new service
      pdf_data = FbPdfService.generate_pdf_from_html(sample_html, 'http://localhost:3000')
      
      # Save to file
      filename = "test_fb_pdf_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf"
      filepath = Rails.root.join('tmp', filename)
      
      File.binwrite(filepath, pdf_data)
      
      puts "✅ PDF generated successfully!"
      puts "📄 File saved to: #{filepath}"
      puts "📊 File size: #{File.size(filepath)} bytes"
      
      # Compare with current Grover service for reference
      puts "\n🔄 Generating comparison PDF using current Grover service..."
      
      PdfService.with_pdf_data_from_html_string(sample_html, 'http://localhost:3000') do |grover_pdf_data|
        grover_filename = "test_grover_pdf_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf"
        grover_filepath = Rails.root.join('tmp', grover_filename)
        
        File.binwrite(grover_filepath, grover_pdf_data)
        
        puts "📄 Grover PDF saved to: #{grover_filepath}"
        puts "📊 Grover file size: #{File.size(grover_filepath)} bytes"
      end
      
      puts "\n🎉 PoC Test Complete!"
      puts "📁 Check the files in #{Rails.root.join('tmp')} to compare outputs"
      
    rescue FbPdfService::PdfGenerationError => e
      puts "❌ FB PDF Generation failed: #{e.message}"
      puts "🔍 Check the FB PDF Generator logs for more details"
      
    rescue => e
      puts "❌ Unexpected error: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
  
  desc "Test FB PDF Generator with real CCQ assessment data"
  task test_with_real_data: :environment do
    puts "🔧 Testing FB PDF Generator with real CCQ assessment data..."
    
    # This would use actual assessment data from the session
    # For now, we'll simulate a realistic assessment
    
    session_data = {
      "assessment_code" => "TEST-#{rand(100000..999999)}",
      "client" => {
        "age_range" => "18-59",
        "has_partner" => false
      },
      "property" => {
        "house_value" => 250000,
        "mortgage_remaining" => 180000,
        "shared_ownership" => false
      },
      "income" => {
        "employment_income" => 2500,
        "benefits_income" => 0,
        "maintenance_income" => 0
      },
      "outgoings" => {
        "housing_costs" => 800,
        "childcare_costs" => 0,
        "maintenance_costs" => 0,
        "legal_aid_costs" => 0
      },
      "capital" => {
        "savings" => 5000,
        "investments" => 0,
        "valuables" => 0
      },
      "early_result" => {
        "type" => "eligible",
        "result" => "likely_eligible"
      }
    }
    
    begin
      # Create a model to render realistic content
      @model = CalculationResult.new(session_data)
      @sections = CheckAnswers::SectionListerService.call(session_data)
      @is_pdf = true
      
      # Render the actual download template
      html = ApplicationController.new.render_to_string({
        template: "results/download",
        layout: "download_application",
        assigns: {
          model: @model,
          sections: @sections,
          is_pdf: @is_pdf
        }
      })
      
      puts "🔄 Generating PDF from real CCQ template..."
      
      pdf_data = FbPdfService.generate_pdf_from_html(html, 'http://localhost:3000')
      
      filename = "ccq_real_assessment_#{Time.current.strftime('%Y%m%d_%H%M%S')}.pdf"
      filepath = Rails.root.join('tmp', filename)
      
      File.binwrite(filepath, pdf_data)
      
      puts "✅ Real assessment PDF generated successfully!"
      puts "📄 File saved to: #{filepath}"
      puts "📊 File size: #{File.size(filepath)} bytes"
      
    rescue => e
      puts "❌ Error generating real assessment PDF: #{e.message}"
      puts e.backtrace.first(5).join("\n")
    end
  end
end