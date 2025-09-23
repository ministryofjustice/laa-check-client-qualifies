class PdfService
  class << self
    def with_pdf_data_from_html_string(html_string, display_url)
      # Use native PDFKit instead of Grover for Rails 8 compatibility
      Rails.logger.info "Generating PDF using native PDFKit (replacing Grover)"
      
      pdf_data = generate_pdf_from_html(html_string)
      yield pdf_data
    end

    private

    def generate_pdf_from_html(html_string)
      # Process HTML to inline CSS and prepare for PDF generation
      processed_html = process_html_for_pdf(html_string)
      
      # Configure PDFKit with Rails 8 compatible options
      kit = PDFKit.new(processed_html,
        page_size: 'A4',
        print_media_type: true,
        margin_top: '2cm',
        margin_bottom: '2cm', 
        margin_left: '1cm',
        margin_right: '1cm',
        encoding: 'UTF-8',
        quiet: true
      )
      
      kit.to_pdf
    end

    def process_html_for_pdf(html_string)
      # Parse HTML and process stylesheet links
      doc = Nokogiri::HTML::DocumentFragment.parse(html_string)
      
      # Find and process stylesheet links
      stylesheet_links = doc.css('link[rel="stylesheet"]')
      combined_css = ""
      
      stylesheet_links.each do |link|
        href = link['href']
        if href&.start_with?('/assets/')
          # Get compiled CSS from Propshaft
          css_content = get_compiled_css(href)
          combined_css += css_content if css_content
          link.remove
        end
      end
      
      # Add combined CSS as inline style
      if combined_css.present?
        style_tag = doc.document.create_element('style', combined_css)
        style_tag['type'] = 'text/css'
        
        # Insert style tag at the beginning of the document
        if doc.children.first
          doc.children.first.add_previous_sibling(style_tag)
        else
          doc.add_child(style_tag)
        end
      end
      
      doc.to_html
    end

    def get_compiled_css(asset_path)
      # Use Propshaft to get compiled CSS content
      begin
        # Remove /assets/ prefix and any fingerprint
        logical_path = asset_path.gsub(/^\/assets\//, '').gsub(/-[a-f0-9]+\.css$/, '.css')
        
        # Try to find the asset through Propshaft
        if Rails.application.assets
          asset = Rails.application.assets.load_path.find(logical_path)
          if asset
            content = asset.content
            Rails.logger.info "✅ Loaded CSS: #{logical_path} (#{content.length} bytes)"
            return content
          end
        end
        
        Rails.logger.warn "❌ Could not find CSS asset: #{logical_path}"
        ""
      rescue => e
        Rails.logger.error "❌ Error loading CSS #{asset_path}: #{e.message}"
        ""
      end
    end
  end
end
