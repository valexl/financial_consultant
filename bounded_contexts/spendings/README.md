# Spendings subdomain

In the beginning of each month I create info about this month. It contains info about expected living expenses, utility costs, mortgage and credit payments, rent payments, some big purchases. Every single day I track spendings heppening during this day. They can be either what was already planned (like mortage payment) or some living expenses (like food or cinema) or something unpredictable (like broken washing machine) or something that you planned many many days ago - trip to another country. Some of purchases can be canceled fully or partially. That means that sum must be changeable. Also the same for category - it can be set by mistake and you can change the category.

As there is information about planning expenses - it's possible to see hom much moeny from planned were already spent for each category. Also it's possible to compare difference between planning expenses and real one and build a super rude prediction for the next month and same month in the next year.

Also you can receive sallary in one currency, live in the country with the second currency and stay in the some country for a while with the third currency. The same for subscriptions. Some of subscriptions might be by USD and you have to convert them to your main currency - RUB. 


## Ubiquitous language

Defenition: 
- **SpendingCategory** - like food, utility, cinema, mortgage and etc
- **Month** - period, keeps info about expected and real expenses in all spending categories. You can create it and update information about epxected expenses. It also accumulates info about spendings happened during this month. 
- **Day** - period, keeps information about a real expenses happened in all spending groups. 
- **Expense** - keep information about amount of spending money, day and category of this spending. You can create it, modife. Every money changes in Expense will trigger the process of accumulation for day and month. 

Actions: 
- **Track expense** - process when you put your expense for one spefic date. There might be a lot of track spending actions and all of them are about past.
- **Cancel tracked expense** - in some cases you need to cancel your purchase. For example defective TV. This process helps you to cancel what was already planned. 
- **Change tracked expense sum** - you can make a typo in sum
- **Change tracked expense comment** - you can make a typo in comment
- **Change tracked expense category** - you can make a typo in category
- **Change tracked expense currency** - you can make a typo in currency
- **Convert money from CURRENCY to ANOTHER CURRENCY** - if purchase was made not in the main currency
- **Shows expense for month in currency**


Month has many days. There may be several expenses from different categories and in different currencies. Each of such expenses you'll track. You can't have a negative sum in tracking expenses. Some of purchases might be canceled that will trigger cancelgin/removing expenses. You can see the stats for a month to see how much money there were spent.


## Domain

### Entities

- Month
  id - should it be external??

- Category
  id - should it be external??

- Expense
  id - local (should it be a entity?)
  change_sum action
  change_category action
  change_comment action
  change_currency action

### Value Objects

- Day
- Money
- Currency
- Comment

### Services

- TrackExpenseService
- ConvertMoneyToCurrencyInDateService(money, old_currency, new_currency, date)
- ShowExpenseForMonthInCurrencyService (???)

### Events

- MonthHasBeenStartedEvent
- CategoryAddedEvent
- ExpenseTrackedEvent
- ExpenseCanceledEvent
- TrackedExpenseSumModifiedEvent
- TrackedExpenseCategoryChangedEvent










