require 'byebug'

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
end

class SpendingTrackedEvent < BaseEvent
  attr_accessor :spending_id, :date, :category_id, :sum

  def initialize(spending_id:, date:, category_id:, sum:)
    @spending_id = spending_id
    @category_id = category_id
    @date = date
    @sum = sum
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
  def self.handle(event)
    puts '!!!!!!!! EVENT HANDLER !!!!!!!!!!'
    puts "spending_id: #{event.spending_id};category_id: #{event.category_id};date: #{event.date};sum: #{event.sum};"
    puts '!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!!'
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


DomainEventsPublisher.subscribe(SpendingTrackedEvent, SpendingTrackedEventHandler)
spending_factory = SpendingFactory.new
spending_factory.category_id = 1
spending_factory.date = "01.01.2022"
spending_factory.sum = 1000

spending_aggregate = spending_factory.spending_aggregate
spending_aggregate.track
