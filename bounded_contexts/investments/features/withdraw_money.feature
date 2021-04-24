Feature: Withdraw money
  You can witdraw only income of income of income

  Scenario: Withdraw income of income of income
    Given cash equals 100000 RUB
    When investment opening by price 100000 RUB
    * investment closing with 10000 RUB profit
    * investment opening by price 110000 RUB
    * investment closing with 10000 RUB profit
    * investment opening by price 120000 RUB
    * investment closing with 10000 RUB profit
    Then cash should be 130000 "RUB"
    * 69 RUB is withdrawable