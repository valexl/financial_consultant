Feature: Close opened investment
  Process of closing investment

  Scenario: Close opened investment 
    Given cash equals 0 RUB
    * opened investment prices 50000 "RUB"
    When investment closing
    Then cash should be 50000 "RUB"

  Scenario: Close closed investment 
    Given cash equals 0 RUB
    * closed investment prices 50000 "RUB"
    When investment closing
    Then cash should be 0 "RUB"

  Scenario: Close closed investment 
    Given cash equals 0 RUB
    * cash equals 1000 USD
    * cash equals 2000 EUR
    * opened investment prices 50000 "USD"
    When investment closing
    Then cash should be 0 "RUB"
    * cash should be 51000 "USD"
    * cash should be 2000 "EUR"