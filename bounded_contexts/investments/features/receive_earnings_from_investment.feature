Feature: Receive dividend from opened investment
  Process of receiving dividend from opened investment

  Scenario: Receive 1000 RUB dividend from Investment
    Given cash equals 50000 RUB
    * opened investment prices 50000 "RUB"
    When 1000 "RUB" dividend comes from this investment
    Then cash should be 51000 "RUB"

  Scenario: Receive 1000 RUB dividend from Investment
    Given cash equals 50000 RUB
    * closed investment
    When 1000 "RUB" dividend comes from this investment
    Then cash should be 50000 "RUB"

  Scenario: Receive -1000 RUB dividend from Investment
    Given cash equals 50000 RUB
    * opened investment prices 50000 "RUB"
    When -1000 "RUB" dividend comes from this investment
    Then cash should be 50000 "RUB"