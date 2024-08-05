module Cfe
  class ProceedingsPayloadService
    PROCEEDING_TYPES = { "immigration" => "IM030", "asylum" => "IA031", "other" => "SE003", "domestic_abuse" => "DA001" }.freeze
    class << self
      def call(session_data, payload)
        check = Check.new session_data
        unless check.under_eighteen_no_means_test_required?
          payload[:proceeding_types] = if check.certificated?
                                         payload_from_certificated_journey session_data
                                       else
                                         payload_from_immigration_and_asylum_choices session_data
                                       end
        end
      end

      def payload_from_certificated_journey(session_data)
        form = BaseService.instantiate_form(session_data, DomesticAbuseApplicantForm)
        ccms_code = if form.domestic_abuse_applicant
                      PROCEEDING_TYPES["domestic_abuse"]
                    else
                      type_form = BaseService.instantiate_form(session_data, ImmigrationOrAsylumTypeUpperTribunalForm)
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

      def payload_from_immigration_and_asylum_choices(session_data)
        form = BaseService.instantiate_form(session_data, ImmigrationOrAsylumForm)
        ccms_code = if form.immigration_or_asylum
                      type_form = BaseService.instantiate_form(session_data, ImmigrationOrAsylumTypeForm)
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
end
