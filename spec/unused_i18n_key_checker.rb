class UnusedI18nKeyChecker
  def self.log(key)
    @used_keys ||= []
    @used_keys << key.to_s unless @used_keys.include?(key.to_s)
  end

  def self.check_unused_keys(ignore_stems: [])
    return unless ENV["CHECK_UNUSED_KEYS"]

    mappings = YAML.load_file(Rails.root.join("config/locales/en.yml"))
    defined_keys = define_keys(mappings["en"])
    not_ignored_defined_keys = defined_keys.reject do |defined_key|
      ignore_stems.any? { defined_key.starts_with?(_1) }
    end

    unused_keys = not_ignored_defined_keys - @used_keys

    puts "\nObsolete i18n keys detected:\n#{unused_keys.join("\n")}" if unused_keys.any?
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
