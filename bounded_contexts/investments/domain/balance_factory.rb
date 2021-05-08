class BalanceFactory
  def self.build(rub_value:, usd_value:, eur_value:)
    builder = MoneyBuilder.new
    money_creator = MoneyCreator.new(builder)
    
    cash = Cash.new(
      rub_money: money_creator.build_rub(value: rub_value),
      usd_money: money_creator.build_usd(value: usd_value),
      eur_money: money_creator.build_eur(value: eur_value)
    )
    Balance.new(cash: cash)
  end
end
