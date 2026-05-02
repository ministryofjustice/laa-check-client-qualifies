return unless Rails.env.test? || Rails.env.development?

Rails.application.config.after_initialize do
  $stdout.sync = true

  if ModeConfig.mode != CCQ_BOOT_MODE
    warn <<~WARN
      ⚠️ =============================================

      CCQ boot mode    : #{CCQ_BOOT_MODE.upcase}
      CCQ running mode : #{ModeConfig.mode.upcase}

      CCQ_MODE defaults to STANDALONE.
      For more info, see config/application.rb:12

      Use:
      - `bin/dev`
      - `foreman run bin/rails s`
      - `CCQ_MODE=embedded bin/rails s`

      ⚠️ =============================================
    WARN
  end

  unless Rails.env.test?
    mode_name = ModeConfig.embedded? ? "EMBEDDED (Redis)" : "STANDALONE (Solid Cache)"

    Rails.logger.info(
      <<~CCQ_MODE,
        ========================================
        🚀 BOOTING CCQ IN #{mode_name} MODE
        ========================================
    CCQ_MODE
    )
  end
end
