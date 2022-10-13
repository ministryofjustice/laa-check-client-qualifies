class Gbp < ActiveModel::Type::Decimal
  # When a monetary value is provided by a form submission, we are only interested
  # in the value to 2 decimal places, and discard any more fine detail immediately
  def cast(value)
    super(value&.delete(","))&.round(2)
  end
end

ActiveModel::Type.register(:gbp, Gbp)
