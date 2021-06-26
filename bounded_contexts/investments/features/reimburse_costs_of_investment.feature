Feature: Reimburse costs of investment
  Process of reimbursing costs of investment

  Scenario: Reimburse 1000 RUB costs of Investment
    Given cash equals 50000 RUB
    * opened investment prices 0 "RUB"
    When 1000 "RUB" costs come for this investment
    Then cash should be 49000 "RUB"

  Scenario: Reimburse 1000 RUB costs of Investment
    Given cash equals 50000 RUB
    * closed investment
    When 1000 "RUB" costs come for this investment
    Then cash should be 50000 "RUB"

  Scenario: Reimburse 1000 RUB costs of Investment
    Given cash equals 0 RUB
    * opened investment prices 0 "RUB"
    When 1000 "RUB" costs come for this investment
    Then cash should be 0 "RUB"

  Scenario: Reimburse -1000 RUB costs of Investment
    Given cash equals 50000 RUB
    * opened investment prices 0 "RUB"
    When -1000 "RUB" costs come for this investment
    Then cash should be 50000 "RUB"
