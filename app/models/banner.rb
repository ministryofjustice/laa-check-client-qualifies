class Banner < ApplicationRecord
  attribute :display_from_utc, :datetime
  attribute :display_until_utc, :datetime
  attribute :title, :string
  attribute :published, :boolean, default: false
  before_save :apply_govuk_classes

  has_rich_text :content

  validates :display_from_utc, :display_until_utc, :title, :published, :content, presence: true

  def self.for_display
    where(published: true).where("display_from_utc <= CURRENT_DATE AND display_until_utc >= CURRENT_DATE")
  end

  # RailsAdmin uses a pre 2.0 version of Trix that doesn't allow adding custom CSS classes to elements
  # as you type, so we have to apply them before save instead
  def apply_govuk_classes
    self.content = GovukStyleService.call(content)
  end
end
