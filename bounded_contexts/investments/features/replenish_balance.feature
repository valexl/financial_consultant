Feature: Replenish Balance
  Process of replenish balance

  Scenario Outline:
  Scenario: Replenish 50000 RUB
    Given money is <given money value> "<given money currency>"
    When balance RUB cash is <RUB cash>
    * balance EUR cash is <EUR cash>
    * balance USD cash is <USD cash>
    Then balance RUB cash should be <amount of money in RUB>
    * balance EUR cash should be <amount of money in EUR>
    * balance USD cash should be <amount of money in USD>

  Examples:
    | given money value | given money currency | RUB cash | EUR cash | USD cash | amount of money in RUB | amount of money in EUR | amount of money in USD |
    | 50000             | RUB                  | 0        | 0        | 0        | 50000                  | 0                      | 0                      |
    | 0                 | RUB                  | 0        | 0        | 0        | 0                      | 0                      | 0                      |
    | -1000             | RUB                  | 0        | 0        | 0        | 0                      | 0                      | 0                      |
    | 10000             | EUR                  | 0        | 0        | 0        | 0                      | 10000                  | 0                      |
    | 80000             | USD                  | 0        | 0        | 0        | 0                      | 0                      | 80000                  |
    | -1000             | RUB                  | 0        | 0        | 0        | 0                      | 0                      | 0                      |
    | 50000             | RUB                  | 1000     | 200      | 500      | 51000                  | 200                    | 500                    |
    | 20000             | EUR                  | 1000     | 200      | 500      | 1000                   | 20200                  | 500                    |
    | 777               | USD                  | 1000     | 200      | 500      | 1000                   | 200                    | 1277                   |
    | 100               | CFP                  | 1000     | 200      | 500      | 1000                   | 200                    | 500                    |

