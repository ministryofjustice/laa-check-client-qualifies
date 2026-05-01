return if Rails.env.test?

Rails.application.config.after_initialize do
  mode_name = ModeConfig.embedded? ? "EMBEDDED (Redis)" : "STANDALONE (Solid Cache)"

  banner = "\n========================================\n" \
           "🚀 BOOTING IN #{mode_name} MODE\n" \
           "========================================\n"

  Rails.logger.info(banner)
end
