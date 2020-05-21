class PaymentProviderFactory
  def self.provider
    @provider ||= Provider.new
  rescue StandardError
    @provider ||= PaymentProviderFactory.new
  end

  def debit_card(user) end;
end
