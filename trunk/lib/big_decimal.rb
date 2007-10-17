class BigDecimal
  def to_cents
    (self * 100).round
  end
end

