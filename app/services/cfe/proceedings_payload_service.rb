module Cfe
  class ProceedingsPayloadService < BaseService
    PROCEEDING_TYPES = { "immigration" => "IM030", "asylum" => "IA031", "other" => "SE003", "domestic_abuse" => "DA001" }.freeze
    def call
      if relevant_form?(:domestic_abuse_applicant)
        payload[:proceeding_types] = payload_from_certificated_journey
      elsif relevant_form?(:immigration_or_asylum)
        payload[:proceeding_types] = payload_from_immigration_and_asylum_choices
      end
    end

    def payload_from_certificated_journey
      form = instantiate_form(DomesticAbuseApplicantForm)
      ccms_code = if form.domestic_abuse_applicant
                    PROCEEDING_TYPES["domestic_abuse"]
                  else
                    type_form = instantiate_form(ImmigrationOrAsylumTypeUpperTribunalForm)
                    if type_form.immigration_or_asylum_type_upper_tribunal == "immigration_upper"
                      PROCEEDING_TYPES["immigration"]
                    elsif type_form.immigration_or_asylum_type_upper_tribunal == "asylum_upper"
                      PROCEEDING_TYPES["asylum"]
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
