class WithdrawableItemsIterator
  include Enumerable

  def initialize(items)
    @items = items
  end

  def each(&block)
    @items.select { |item| item.level >= 4 }.each(&block)
  end
end