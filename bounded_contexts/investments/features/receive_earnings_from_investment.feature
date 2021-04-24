Feature: Receive earnings from opened investment
  Process of receiving earnings from opened investment

  Scenario: Receive 1000 RUB earnings from Investment
    Given cash equals 50000 RUB
    * opened investment
    When 1000 RUB earnings come from this investment
    Then cash should be 51000 "RUB"

  Scenario: Receive 1000 RUB earnings from Investment
    Given cash equals 50000 RUB
    * closed investment
    When 1000 RUB earnings come from this investment
    Then cash should be 50000 "RUB"

  Scenario: Receive -1000 RUB earnings from Investment
    Given cash equals 50000 RUB
    * opened investment
    When -1000 RUB earnings come from this investment
    Then cash should be 50000 "RUB"