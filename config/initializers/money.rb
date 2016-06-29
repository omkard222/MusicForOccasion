#MoneyRails.configure do
#  currencies = Money::Currency.table
#  currencies.keys.each do |currency|
#    begin
#      GoogCurrency.send("usd_to_#{currency}", 1)
#    rescue
#      Money::Currency.table.delete(currency)
#    end
#  end
#end
