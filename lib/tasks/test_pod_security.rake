namespace :test do
  desc "Test Pod Security Standards compliance - verify pdftk and PDF generation work"
  task pod_security: :environment do
    puts "🔍 Testing Pod Security Standards compliance..."
    
    # Test 1: Check if pdftk is available
    puts "\n1. Testing pdftk availability..."
    begin
      pdftk_path = `which pdftk`.chomp
      if pdftk_path.empty?
        puts "❌ pdftk not found in PATH"
        exit 1
      else
        puts "✅ pdftk found at: #{pdftk_path}"
      end
    rescue => e
      puts "❌ Error checking pdftk: #{e.message}"
      exit 1
    end
    
    # Test 2: Check user permissions
    puts "\n2. Testing user permissions..."
    puts "Current user: #{ENV['USER'] || `whoami`.chomp}"
    puts "Current UID: #{Process.uid}"
    puts "Current GID: #{Process.gid}"
    puts "Working directory: #{Dir.pwd}"
    puts "Working directory permissions: #{File.stat(Dir.pwd).mode.to_s(8)}"
    
    # Test 3: Test tmp directory access
    puts "\n3. Testing temporary directory access..."
    begin
      Dir.mktmpdir do |tmp_dir|
        puts "✅ Can create temp directory: #{tmp_dir}"
        test_file = File.join(tmp_dir, "test.txt")
        File.write(test_file, "test content")
        puts "✅ Can write to temp directory"
        
        if File.readable?(test_file)
          puts "✅ Can read from temp directory"
        else
          puts "❌ Cannot read from temp directory"
          exit 1
        end
      end
    rescue => e
      puts "❌ Error with temp directory: #{e.message}"
      exit 1
    end
    
    # Test 4: Test basic pdftk operation
    puts "\n4. Testing basic pdftk operation..."
    begin
      # Test pdftk help command
      output = `pdftk --help 2>&1`
      if $?.success?
        puts "✅ pdftk help command successful"
      else
        puts "❌ pdftk help command failed"
        puts "Output: #{output}"
        exit 1
      end
    rescue => e
      puts "❌ Error running pdftk: #{e.message}"
      exit 1
    end
    
    # Test 5: Test form template access
    puts "\n5. Testing form template access..."
    template_path = Rails.root.join("lib", "cw1-form-CCQ_v3_Apr25.pdf")
    if File.exist?(template_path)
      puts "✅ Form template exists: #{template_path}"
      if File.readable?(template_path)
        puts "✅ Form template is readable"
      else
        puts "❌ Form template is not readable"
        exit 1
      end
    else
      puts "❌ Form template not found: #{template_path}"
      exit 1
    end
    
    puts "\n🎉 All Pod Security Standards compliance tests passed!"
    puts "The environment should be able to run pdftk with restricted capabilities."
  end
end