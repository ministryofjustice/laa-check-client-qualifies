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
      form = instantiate_form(MatterTypeForm)
      [
        {
          ccms_code: PROCEEDING_TYPES.fetch(form.matter_type),
          client_involvement_type: "A",
        },
      ]
    end

    def payload_from_immigration_and_asylum_choices
      form = instantiate_form(ImmigrationOrAsylumForm)
      ccms_code = if form.immigration_or_asylum
                    type_form = instantiate_form(ImmigrationOrAsylumTypeForm)
                    if type_form.immigration_or_asylum_type == "immigration_clr"
                      PROCEEDING_TYPES["immigration"]
                    else
                      PROCEEDING_TYPES["asylum"]
                    end
                  else
                    PROCEEDING_TYPES["other"]
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
