module CheckAnswers
  class SectionListerService
    def self.call
      new.call
    end

    def call
      YAML.load_file(Rails.root.join("app/lib/check_answers_fields.yml")).with_indifferent_access
    end
  end
end
