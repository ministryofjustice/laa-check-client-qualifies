module Cfe
  class ProceedingsPayloadService < BaseService
    PROCEEDING_TYPES = { "immigration" => "IM030", "asylum" => "IA031", "other" => "SE003", "domestic_abuse" => "DA001" }.freeze
    def call
      payload[:proceeding_types] = if relevant_form?(:matter_type)
                                     payload_from_matter_type
                                   else
                                     payload_from_immigration_and_asylum_choices
                                   end
    end

    def payload_from_matter_type
      [
        {
          ccms_code: PROCEEDING_TYPES.fetch(check.matter_type),
          client_involvement_type: "A",
        },
      ]
    end

    def payload_from_immigration_and_asylum_choices
      ccms_code = if !check.immigration_or_asylum
                    PROCEEDING_TYPES["other"]
                  elsif check.immigration_or_asylum_type == "immigration_clr"
                    PROCEEDING_TYPES["immigration"]
                  else
                    PROCEEDING_TYPES["asylum"]
                  end

      [
        {
          ccms_code:,
          client_involvement_type: "A",
        },
      ]
    end
  end
end
