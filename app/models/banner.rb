class Banner < ApplicationRecord
  before_save :apply_govuk_classes

  has_rich_text :content

  validates :display_from_utc, :display_until_utc, :title, :content, presence: true

  def self.for_display
    where(published: true).where("display_from_utc <= CURRENT_TIMESTAMP AND display_until_utc >= CURRENT_TIMESTAMP")
  end

  # RailsAdmin uses a pre 2.0 version of Trix that doesn't allow adding custom CSS classes to elements
  # as you type, so we have to apply them before save instead
  def apply_govuk_classes
    self.content = GovukStyleService.call(content)
  end
end

#------------------------------------------------------------------------------
# Banner
#
# Name              SQL Type             Null    Primary Default
# ----------------- -------------------- ------- ------- ----------
# id                bigint               false   true
# title             character varying    false   false
# display_from_utc  timestamp without time zone false   false
# display_until_utc timestamp without time zone false   false
# published         boolean              false   false   false
# created_at        timestamp(6) without time zone false   false
# updated_at        timestamp(6) without time zone false   false
#
#------------------------------------------------------------------------------
