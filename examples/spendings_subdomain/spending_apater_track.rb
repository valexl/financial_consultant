require 'byebug'
require 'json'

################################
######## VALUE OBJECTS #########
################################

class TrackingIdValueObject
  attr_reader :id
  def initialize(id=nil)
    @id ||= rand(1000000) # TODO: replace me with the code generated uniq value
  end

  def to_s
    @id
  end
end

class DateValueObject
  attr_reader :date
  def initialize(date)
    @date = date
  end

  def to_s
    @date
  end
end

class CategoryIdValueObject
  attr_reader :category_id
  def initialize(category_id)
    @category_id = category_id
  end

  def to_s
    @category_id
  end  
end

class SumValueObject
  attr_reader :sum
  def initialize(sum)
    @sum = sum
  end

  def to_s
    @sum
  end
end

################################
######## DOMAIN EVENTS #########
################################

class BaseEvent
  def to_json
    raise 'Implement me'
  end
end

class SpendingTrackedEvent < BaseEvent
  attr_accessor :spending_id, :date, :category_id, :sum

  def initialize(spending_id:, date:, category_id:, sum:)
    @spending_id = spending_id
    @category_id = category_id
    @date = date
    @sum = sum
  end

  def to_json
    {
      event_class: self.class.to_s,
      spending_id: spending_id,
      category_id: category_id,
      date: date,
      sum: sum,
    }.to_json
  end
end

class DomainEventsPublisher
  def self.publish(event)
    @subscribers ||= {}
    (@subscribers[event.class] || []).each do |subscriber|
      subscriber.handle(event)
    end
  end

  def self.subscribe(event_class, event_handler)
    @subscribers ||= {}
    @subscribers[event_class] ||= []
    @subscribers[event_class].push(event_handler)
  end
end

###########################################################
######## APPLICATION LAYER DOMAIN EVENTS HANDLER #########
###########################################################

class SpendingTrackedEventHandler
  def self.repository=(repository)
    @repository = repository
  end

  def self.handle(event)
    puts '!!!!!!!! EVENT HANDLER !!!!!!!!!!'
    puts "spending_id: #{event.spending_id};category_id: #{event.category_id};date: #{event.date};sum: #{event.sum};"
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
    @repository.save(event) if !!(@repository)
  end
end


################################
##### ENTITY AND AGGREGATE #####
################################


class SpendingEntity
  attr_reader :id, :date, :category_id, :sum

  def initialize(id:, date:, category_id:, sum:)
    raise 'Incorrect id type' if !id.is_a?(TrackingIdValueObject)
    raise 'Incorrect date type' if !date.is_a?(DateValueObject)
    raise 'Incorrect category_id type' if !category_id.is_a?(CategoryIdValueObject)
    raise 'Incorrect sum type' if !sum.is_a?(SumValueObject)

    @id = id
    @date = date
    @category_id = category_id
    @sum = sum
  end
end

class SpendingAgregate
  def initialize(spending_entity)
    @spending_entity = spending_entity
  end

  def track
    event = SpendingTrackedEvent.new(
      spending_id: id.id,
      date: date.date,
      category_id: category_id.category_id,
      sum: sum.sum
    )
    DomainEventsPublisher.publish(event)
  end

  def id
    @spending_entity.id
  end

  def date
    @spending_entity.date
  end

  def sum
    @spending_entity.sum
  end

  def category_id
    @spending_entity.category_id
  end
end

class SpendingFactory
  attr_reader :category_id, :date, :sum
  private :category_id, :date, :sum

  def spending_aggregate
    spending_entity = SpendingEntity.new(
      id: id,
      date: date,
      category_id: category_id,
      sum: sum,
    )

    SpendingAgregate.new(spending_entity)
  end

  def id
    TrackingIdValueObject.new(@id)
  end

  def id=(value)
    @id = value
  end

  def date=(value)
    @date = DateValueObject.new(value)
  end

  def category_id=(value)
    @category_id = CategoryIdValueObject.new(value)
  end

  def sum=(value)
    @sum = SumValueObject.new(value)
  end
end


###############################
###############################
###############################

class DomainEventsRepositoryPort
  def save(event)
    raise 'Implement me'
  end

  def all
    raise 'Implement me'
  end
end

class MemoryDomainEventsRepository < DomainEventsRepositoryPort
  def initialize
    @memory = []
  end

  def save(event)
    @memory.push(event.to_json)
  end

  def all
    @memory.each do |item|
      data = JSON.parse(item).transform_keys(&:to_sym)
      event_class = data.delete(:event_class)
      Module.const_get(event_class).new(data)
    end
  end
end

class SpendingsRepositoryPort
  def save(spending)
    raise 'Implement me'
  end

  def for_date(date)
    raise 'Implement me'
  end
end

class MemorySpendingsRepository < SpendingsRepositoryPort
  def initialize
    @memory = {}
  end

  def save(spending)
    @memory[spending.date.date] ||= []
    @memory[spending.date.date].push(
      id: spending.id.id,
      date: spending.date.date,
      category_id: spending.category_id.category_id,
      sum: spending.sum.sum,
    )
  end

  def for_date(date)
    @memory[date].map do |item|
      spending_factory = SpendingFactory.new
      spending_factory.id = item[:id]
      spending_factory.date = item[:date]
      spending_factory.category_id = item[:category_id]
      spending_factory.sum = item[:sum]

      spending_factory.spending_aggregate
    end
  end
end

###############################
###############################
###############################


class SpendingsPort
  def initialize(repository)
    @repository = repository
  end

  def track(params)
    raise 'Implement me'
  end

  def update
    raise 'Implement me'
  end

  def cancel
    raise 'Implement me'
  end
end

class SpendingsAdapter < SpendingsPort
  def track(params)
    spending_factory = SpendingFactory.new
    spending_factory.category_id = params[:category_id]
    spending_factory.date = params[:date]
    spending_factory.sum = params[:sum]

    spending_aggregate = spending_factory.spending_aggregate
    spending_aggregate.track
    @repository.save(spending_aggregate)
  end
end

events_repository = MemoryDomainEventsRepository.new
SpendingTrackedEventHandler.repository = events_repository
DomainEventsPublisher.subscribe(SpendingTrackedEvent, SpendingTrackedEventHandler)
repository = MemorySpendingsRepository.new
spending_adapter = SpendingsAdapter.new(repository)
spending_adapter.track(date: "01.01.2022", category_id: 1, sum: 100_000)
spending_adapter.track(date: "01.01.2022", category_id: 2, sum: 200_000)
spending_adapter.track(date: "02.01.2022", category_id: 2, sum: 300_000)
repository.for_date("01.01.2022").each_with_index do |record, index|
  puts "position - #{index}"
  puts "#{record.id.id} - #{record.sum.sum}"
end

events_repository.all.each do |event|
  puts event.to_json
end











