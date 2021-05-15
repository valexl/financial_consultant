Feature: Open an investment
  Process of opening an investment

  Scenario: Open Apartment Investment costs 40 000 RUB
    Given investment costs 40000 "RUB"
    * cash equals 50000 RUB
    When opens this investment
    Then cash should be 10000 "RUB"
    * new opened investment 
    * total equity should be 50000 "RUB"

  Scenario: Open Apartment Investment costs 40 000 RUB
    Given investment costs 40000 "RUB"
    * cash equals 40000 RUB
    When opens this investment
    Then cash should be 0 "RUB"
    * new opened investment 
    * total equity should be 40000 "RUB"

  Scenario: Open Apartment Investment costs 40 000 RUB
    Given investment costs 40000 "RUB"
    * cash equals 20000 RUB
    When opens this investment
    Then cash should be 20000 "RUB"
    * no new investments
    * total equity should be 20000 "RUB"        

  Scenario: Open Apartment Investment costs 1 USD
    Given investment costs 1 "USD"
    * cash equals 50000 RUB
    When opens this investment
    Then cash should be 50000 "RUB"
    * no new investments
    * total equity should be 50000 "RUB"