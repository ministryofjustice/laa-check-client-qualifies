module Screens
  class ListerService
    def self.call(estimate = nil)
      new.call(estimate)
    end

    def call(estimate)
      data = YAML.load_file(Rails.root.join("app/lib/screens.yml")).with_indifferent_access
      data[:sections].map { |name, content| interpret(name, content, estimate) }.flatten.compact
    end

    def interpret(section_name, section_content, estimate, check_answer_group: nil)
      return if should_skip?(section_content, estimate)

      return build_screen(section_name, check_answer_group) if section_content[:type] == "screen"

      build_section(section_name, section_content, estimate, check_answer_group)
    end

    def should_skip?(section_content, estimate)
      return true if section_content[:skip_if].present? && estimate&.send(section_content[:skip_if])

      section_content[:skip_unless].present? && estimate && !estimate&.send(section_content[:skip_unless])
    end

    def build_screen(section_name, check_answer_group)
      OpenStruct.new(name: section_name.to_sym, check_answer_group:)
    end

    def build_section(section_name, section_content, estimate, check_answer_group)
      mini_loop = (section_name if section_content[:check_answer_group]) || check_answer_group
      section_content[:sub_elements].map do |name, content|
        interpret(name, content, estimate, check_answer_group: mini_loop)
      end
    end
  end
end
