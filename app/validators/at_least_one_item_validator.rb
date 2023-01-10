class AtLeastOneItemValidator < ActiveModel::EachValidator
  # If the 'exclusive' option is picked, then no items are sent
  # otherwise we should get at least 2 (a blank plus at least one selected)
  def validate_each(record, attribute, value)
    if value.size == 1
      record.errors.add(attribute, :at_least_one_item, **options.merge(value:))
    end
  end
end
