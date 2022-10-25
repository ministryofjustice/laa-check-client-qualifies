module CheckAnswers
  class RelevantSectionFinderService
    def self.call(step, session_data)
      new(step, session_data).call
    end

    def initialize(step, session_data)
      @step = step
      @session_data = session_data
    end

    def call
      sections = SectionListerService.call(@session_data)
      nested_pairs = sections.map do |section|
        section.subsections.map do |subsection|
          subsection.fields.map do |field|
            {
              key: field.screen || subsection.screen || section.screen,
              value: section.label,
            }
          end
        end
      end

      dictionary = nested_pairs.flatten.map { [_1[:key], _1[:value]] }.to_h

      dictionary.fetch(@step.to_s)
    end
  end
end
