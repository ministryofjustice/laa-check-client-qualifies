# We use this class inside PartnerForm instead of BenefitModel so that if there are
# any validation errors, ActiveModel uses the `partner_benefit_model` I18n key
# instead of the `benefit_model` one. This allows us to customise error messages
# when dealing with partner benefits compared to client benefits
class PartnerBenefitModel < BenefitModel; end
