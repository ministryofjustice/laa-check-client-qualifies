# Prevent eager-load crashes in Embedded mode.
#
# These models rely on gems (Devise, ActionText, etc.) that are disabled or
# excluded from the embedded bundle. Ignoring them stops Zeitwerk from
# throwing NoMethodErrors when it encounters missing class macros during boot.
if ModeConfig.embedded?
  Rails.autoloaders.main.ignore(
    Rails.root.join("app/models/admin.rb"),
    Rails.root.join("app/models/banner.rb"),
    Rails.root.join("app/models/change_log.rb"),
  )
end
