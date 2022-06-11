# Personal Financial Consultant

Financial consultant that helps me to handle family budget + manage cash flow and investments

## Diagramms

1. [Events Storming](https://miro.com/app/board/o9J_krwFIEk=/)
2. [UML diagramms](https://drive.google.com/file/d/1vmckzChJR7RhM4oWry2-FIvt2dSfP8Se/view?usp=sharing)
3. [Activity Diagram](https://drive.google.com/file/d/1XGP78gpppnSafWCeLpIZtp59WIMAafqn/view?usp=sharing)
4. [Cross-domain event communication](https://sequencediagram.org/index.html#initialData=participant%20%23red%20Client%0A%0Aentryspacing%201.2%0Aparticipantgroup%20Admin%20application%0A%20%20participantgroup%20%23lightblue%20**Application%20Layer**%0A%20%20%20%20participant%20%23green%20StartMonthCommand%0A%20%20%20%20participant%20%23green%20MonthService%0A%20%20%20%20participant%20%23green%20DomainEventsDispatcher%0A%20%20end%0A%0A%20%20participantgroup%20%23lightgreen%20**Domain%20Layer**%0A%09%0A%20%20%20%20participant%20%23green%20DomainRegistry%0A%20%20%20%20participant%20%23green%20StartMonthService%0A%20%20%20%20participant%20%23green%20MonthStarted%0A%20%20%20%20participant%20%23green%20MonthEntity%0A%20%20%20%20participant%20%23green%20DomainEventPublisher%0A%20%20end%20%0A%0A%20%20participantgroup%20%23gray%20**Port**%0A%09participantgroup%20%23lightgray%20**DB%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20PGMonthRepository%0A%09end%0A%20%20%20%20%0A%20%20%20%20participantgroup%20%23lightgray%20**Event%20BUS%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20KafkaProducer%0A%20%20%20%20%20%20participant%20Serializer%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0Aparticipantgroup%20Spending%20tracker%20application%0A%20%20participantgroup%20%23gray%20**Port**%0A%20%20%20%20participantgroup%20%23lightgray%20**Event%20BUS%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20KafkaMonthStartedConsumer%0A%20%20%20%20end%0A%20%20end%0A%20%20participantgroup%20%23lightblue%20**Application%20Layer**%0A%20%20%20%20participant%20%23blue%20ST_MonthService%0A%20%20%20%20participant%20%23blue%20ST_StartMonthCommand%0A%20%20end%0A%20%20%0A%20%20participantgroup%20%23lightgreen%20**Domain%20Layer**%0A%20%20%20%20participant%20%23blue%20ST_MonthEntity%0A%20%20end%0A%20%20%0A%20%20participantgroup%20%23gray%20**Port**%0A%20%20%20%20participantgroup%20%23lightgray%20**DB%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20ST_PGMonthRepository%0A%20%20%20%20end%0A%20%20end%0A%0Aend%0A%0AClient-%3E*PGMonthRepository%3Anew%0APGMonthRepository--%3EClient%3Arepository%0A%0AClient-%3E*KafkaProducer%3Anew%0AKafkaProducer--%3EClient%3Aproducer%0A%0A%0AClient-%3E*MonthService%3Anew(rpository%2C%20producer)%0AMonthService--%3EClient%3Aapplication_service%0AClient-%3E*StartMonthCommand%3Anew(params)%0AStartMonthCommand--%3EClient%3Acommand%0A%0AClient-%3EMonthService%3Acall(command)%0A%0A%0AMonthService-%3E*DomainEventsDispatcher%3Anew(producer)%0ADomainEventsDispatcher--%3EMonthService%3Adispatcher%0AMonthService-%3EDomainEventPublisher%3Asubscribe(dispatcher)%0AMonthService-%3EDomainRegistry%3Astart_mont_service%0ADomainRegistry-%3E*StartMonthService%3Anew%0ADomainRegistry%3C--StartMonthService%3Aservice%0AMonthService%3C--DomainRegistry%3Aservice%0A%0AMonthService-%3EStartMonthService%3Acall%0A%0AStartMonthService-%3E*MonthEntity%3Anew%0AMonthEntity--%3EStartMonthService%3AmonthEntity%0A%20%20%0AStartMonthService-%3E*MonthStarted%3Anew%0AMonthStarted--%3EStartMonthService%3Aevent%0AStartMonthService-%3EDomainEventPublisher%3Apublish(event)%0ADomainEventPublisher-%3EDomainEventsDispatcher%3Ahandle(event)%0ADomainEventsDispatcher-%3EKafkaProducer%3Aenqueue(event)%0AKafkaProducer-%3E*Serializer%3Aserialize(event)%0ASerializer--%3EKafkaProducer%3AeventPayload%0AKafkaProducer-%3EKafkaProducer%3Apush(eventPayload)%0A%0AStartMonthService--%3EMonthService%3AmonthEntity%0AMonthService-%3EPGMonthRepository%3Asave(monthEntity)%0AMonthService-%3EKafkaProducer%3AsendEvents%0A%0A%0Aabox%20over%20KafkaProducer%2CKafkaMonthStartedConsumer%3AMonthStarted%20Kafka%20message%0A%0A%0AKafkaMonthStartedConsumer-%3E*ST_PGMonthRepository%3Anew%0AKafkaMonthStartedConsumer%3C--ST_PGMonthRepository%3Arepository%0A%0AKafkaMonthStartedConsumer-%3E*ST_MonthService%3Anew(repository)%0AKafkaMonthStartedConsumer%3C--ST_MonthService%3AmonthService%0A%0AKafkaMonthStartedConsumer-%3E*ST_StartMonthCommand%3Anew%0AKafkaMonthStartedConsumer%3C--ST_StartMonthCommand%3AstartMonthCommand%0A%0AKafkaMonthStartedConsumer-%3EST_MonthService%3AstartMonth(startMonthCommand)%0A%0AST_MonthService-%3E*ST_MonthEntity%3Anew%0AST_MonthService%3C--ST_MonthEntity%3AmonthEntity%0A%0AST_MonthService-%3EST_PGMonthRepository%3Acreate(monthEntity)%0AST_MonthService%3C--ST_PGMonthRepository%3Atrue%0A%0AKafkaMonthStartedConsumer%3C--ST_MonthService%3Atrue%0A)
5. [Convert domain events into cross-domain messages](https://sequencediagram.org/index.html#initialData=participant%20%23red%20Client%0A%0Aentryspacing%201.2%0Aparticipantgroup%20Admin%20application%0A%20%20participantgroup%20%23lightblue%20**Application%20Layer**%0A%20%20%20%20participant%20%23green%20ApplicationService%0A%09participant%20%23green%20Command%0A%20%20%20%20participant%20%23green%20ApplicationServiceLifeCycle%0A%20%20end%0A%0A%20%20participantgroup%20%23lightgreen%20**Domain%20Layer**%09%0A%20%20%20%20participant%20%23green%20Entity%0A%20%20%20%20participant%20%23green%20EntityCreated%0A%20%20%20%20participant%20%23green%20DomainEventPublisher%0A%20%20end%20%0A%0A%20%20participantgroup%20%23gray%20**Port**%0A%09participantgroup%20%23lightgray%20**DB%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20PGRepository%0A%09end%0A%20%20%20%20%0A%20%20%20%20participantgroup%20%23lightgray%20**Memory**%0A%20%20%20%20%20%20participant%20%23green%20MemoryEventStore%0A%20%20%20%20end%0A%20%20%20%20%0A%20%20%20%20participantgroup%20%23lightgray%20**Event%20BUS%20Adapter**%0A%20%20%20%20%20%20participant%20%23green%20KafkaProducer%0A%20%20%20%20end%0A%20%20end%0Aend%0A%0AClient-%3EPGRepository%3Anew%20%20%20%20%20%20%20%20%20%20%20%0AClient%3C--PGRepository%3Arepository%20%20%20%20%20%20%20%0A%0A%0A%0A%0AClient-%3E*ApplicationService%3Anew(repository%2C%20event_store)%0A%0AClient%3C--ApplicationService%3Aservice%0A%0AClient-%3E*Command%3Anew%0AClient%3C--Command%3Acommand%20%20%20%0A%0A%0AClient-%3EApplicationService%3Acall(command)%0AApplicationService-%3E*ApplicationServiceLifeCycle%3Anew%0AApplicationServiceLifeCycle-%3E*MemoryEventStore%3Anew%0Anote%20over%20MemoryEventStore%3Ait%20can%20be%20any%20type%20of%20event%20storage%20%5Cn(memory%2C%20pg%2C%20redis%2C%20etc)%0AApplicationServiceLifeCycle%3C--MemoryEventStore%3Aevent_store%0AApplicationService%3C%3C--ApplicationServiceLifeCycle%3Aservice_live_cycle%0AApplicationService-%3EApplicationServiceLifeCycle%3Abegin%0A%0AApplicationServiceLifeCycle-%3EDomainEventPublisher%3Areset%20%20%20%0AApplicationServiceLifeCycle-%3EDomainEventPublisher%3Asubscribe(self)%0AApplicationService-%3E*Entity%3Anew%0AEntity-%3E*EntityCreated%3Anew%0AEntity%3C--EntityCreated%3Aevent%0AEntity-%3EDomainEventPublisher%3Apublish(event)%0ADomainEventPublisher-%3EApplicationServiceLifeCycle%3Ahandle_event(event)%0AApplicationServiceLifeCycle-%3EMemoryEventStore%3Astore(event)%0AApplicationServiceLifeCycle%3C--MemoryEventStore%3Atrue%0AEntity--%3EApplicationService%3Aentity%0AApplicationService-%3EPGRepository%3Acreate(entity)%0A%0A%0AApplicationService-%3EApplicationServiceLifeCycle%3Asuccess%0AApplicationServiceLifeCycle-%3EMemoryEventStore%3Anew_events%0AMemoryEventStore--%3EApplicationServiceLifeCycle%3Aevents%0A%0AApplicationServiceLifeCycle-%3EKafkaProducer%3Abroadcast_events(events)%0Anote%20right%20of%20KafkaProducer%3Asends%20all%20events%20to%20kafka%20consumers%0A)

## Docs

All information you can find on [the wiki page]( https://github.com/valexl/financial_consultant/wiki)