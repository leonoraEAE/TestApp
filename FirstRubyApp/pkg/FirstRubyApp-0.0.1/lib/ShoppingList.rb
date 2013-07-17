class ShoppingList
  List = "LIST"
  attr_reader :place, :created_at
  attr_accessor :type
  
  @@listTotal = 0
  
  def initialize(listType, place)
    @type = listType    
    @place = place
    @basics = "none"
    @@listTotal += 1
    @created_at = Time.now
  end
  
   def initialize_copy(other)
    @created_at = Time.now
  end
  
  def to_s()
    "type: #{@type} | shopping place: #{@place} | basics: #{@basics}"
  end
  
  def basics
    @basics
  end
  
  def basics=(value)
    @basics = value
  end
  
  def ShoppingList.listTotal
    @@listTotal
  end
  
end

list = ShoppingList::new(:food, "shopping")
puts list
list.type = :fun
puts list.type.to_s
puts list
list.basics = "onions"
puts list
puts ShoppingList::List
puts ShoppingList::listTotal