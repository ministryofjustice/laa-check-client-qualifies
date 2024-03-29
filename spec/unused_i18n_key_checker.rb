class UnusedI18nKeyChecker
  def self.log(key)
    return unless ENV["CHECK_UNUSED_KEYS"]

    @used_keys ||= []
    @used_keys << key.to_s unless @used_keys.include?(key.to_s)
  end

  def self.check_unused_keys(ignore: [])
    return unless ENV["CHECK_UNUSED_KEYS"]

    mappings = YAML.load_file(Rails.root.join("config/locales/en.yml"))
    defined_keys = define_keys(mappings["en"])
    not_ignored_defined_keys = defined_keys.reject do |defined_key|
      ignore.any? { defined_key.starts_with?(_1) }
    end

    unused_keys = not_ignored_defined_keys - Array(@used_keys)

    raise "Obsolete i18n keys detected:\n#{unused_keys.join("\n")}" if unused_keys.any?
  end

  def self.define_keys(mappings, prefix = nil)
    keys = []
    mappings.each do |k, v|
      case v
      when String, Array
        keys << "#{prefix}#{k}"
      when Hash
        define_keys(v, "#{prefix}#{k}.").each do |key|
          keys << key
        end
      end
    end
    keys
  end
end

module I18nRegistry
  def lookup(locale, key, scope = [], options = {})
    UnusedI18nKeyChecker.log(key)
    super
  end
end

I18n::Backend::Simple.include I18nRegistry
