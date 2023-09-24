module Cfe
  class ProceedingsPayloadService < BaseService
    PROCEEDING_TYPES = { "immigration" => "IM030", "asylum" => "IA031", "other" => "SE003", "domestic_abuse" => "DA001" }.freeze
    def call
      payload[:proceeding_types] = if relevant_form?(:domestic_abuse_applicant)
                                     payload_from_certificated_journey
                                   else
                                     payload_from_immigration_and_asylum_choices
                                   end
    end

    def payload_from_certificated_journey
      form = instantiate_form(DomesticAbuseApplicantForm)
      ccms_code = if form.domestic_abuse_applicant
                    PROCEEDING_TYPES["domestic_abuse"]
                  else
                    type_form = instantiate_form(ImmigrationOrAsylumTypeUpperTribunalForm)
                    case ccms_code
                    when type_form.immigration_or_asylum_type_upper_tribunal == "immigration_upper"
                      PROCEEDING_TYPES["immigration"]
                    when type_form.immigration_or_asylum_type_upper_tribunal == "asylum_upper"
                      PROCEEDING_TYPES["asylum"]
                    when type_form.immigration_or_asylum_type_upper_tribunal == "none"
                      PROCEEDING_TYPES["other"]
                    else
                      PROCEEDING_TYPES["other"]
                    end
                  end

      [
        {
          ccms_code:,
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
