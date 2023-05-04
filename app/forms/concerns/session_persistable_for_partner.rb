# This module is like SessionPersistable except that it expects that, instead of mapping between
# model attributes and session attributes directly, the session equivalent of each model
# attribute will be prefixed with `partner_`.
module SessionPersistableForPartner
  extend ActiveSupport::Concern
  include SessionPersistableWithPrefix
  PREFIX = "partner_".freeze
end
