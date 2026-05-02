if ModeConfig.embedded?
  Rails.autoloaders.main.ignore(Rails.root.join("app/models/admin.rb"))
end
