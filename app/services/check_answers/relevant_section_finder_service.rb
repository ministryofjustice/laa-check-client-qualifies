module CheckAnswers
  class RelevantSectionFinderService
    def self.call(step)
      new.call(step)
    end

    def call(step)
      data = SectionListerService.call
      relevant_section = data[:sections].find do |section|
        section[:screen] == step.to_s || matching_subsection?(section, step)
      end

      relevant_section&.dig(:label)
    end

    def matching_subsection?(section, step)
      section[:subsections]&.any? do |subsection|
        subsection[:screen] == step.to_s || matching_field?(subsection, step)
      end
    end

    def matching_field?(subsection, step)
      subsection[:fields]&.any? do |field|
        field[:screen] == step.to_s
      end
    end
  end
end
