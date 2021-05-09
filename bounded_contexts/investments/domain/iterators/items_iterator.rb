class ItemsIterator
  include Enumerable

  def initialize(items)
    @items = items
  end

  def each(&block)
    @items.each(&block)
  end

  alias each_with_level each_with_index
end