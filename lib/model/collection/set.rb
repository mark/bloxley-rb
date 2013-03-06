require 'set'

class Bloxley::Set < Bloxley::Base

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(of = nil)
    @set = ::Set.new
    
    if of.kind_of?(Enumerable)
      @set.merge(of)
    elsif of
      insert of
    end
  end

  ###################
  #                 #
  # Ordered Methods #
  #                 #
  ###################
  
  def the_first
    @set.first
  end

  def the_next_after(item)
    # var foundCurrent = false;
    # 
    # for (var k in hash) {
    #       if (foundCurrent) return hash[k]; // We already found the current, so this one is next
    # 
    #     if (current == hash[k]) foundCurrent = true; // We've found the current, so next one is golden.
    # }
    # 
    # return theFirst(); // We got to the end of the list & didn't find another.
  end
  

  ######################
  #                    #
  # Collection Methods #
  #                    #
  ######################
  
  def clear
    @set.clear
  end

  def insert(obj)
    if obj
      @set.add(obj)
    end  
  end
  
  def remove(obj)
    @set.delete?(obj) && obj
  end
  
  ###############
  #             #
  # Set Methods #
  #             #
  ###############
  
  def contains?(obj)
    obj && @set.include?(obj)
  end
  
  def union(other)
    another @set.union(other.set)
  end
  
  def intersection(other)
    another @set.intersection(other.set)
  end
  
  def minus(other)
    another @set.difference(other.set)
  end
  
  ######################
  #                    #
  # Enumerable Methods #
  #                    #
  ######################
  
  def each(meth = nil, &block)
    @set.each { |item| __call(item, meth, &block) }
  end
  
  def select(meth = nil, &block)
    another @set.select { |item| __call(item, meth, &block) }    
  end

  def reject(meth = nil, &block)
    another @set.reject { |item| __call(item, meth, &block) }    
  end
  
  def map(meth = nil, &block)
    another @set.map { |item| __call(item, meth, &block) }
  end
  
  def inject(initial)
    @set.inject(initial) { |accum, item| yield accum, item }
  end

  ######################
  #                    #
  # Enumerable Aliases #
  #                    #
  ######################
  
  alias_method :that_are, :select
  
  alias_method :that_are_not, :reject
  
  ###################
  #                 #
  # Of Type Methods #
  #                 #
  ###################

  def of_type(key)
    that_are { |item| item.key == key }
  end
  
  def not_of_type(key)
    that_are_not { |item| item.key == key }
  end
  
  def are_all_of_type?(key)
    inject(true) { |so_far, item| so_far && item.key == key }
  end
  
  ####################
  #                  #
  # How Many Methods #
  #                  #
  ####################
  
  def how_many
    @set.length
  end
  
  def are_there_any?
    how_many > 0
  end
  
  def is_empty?
    how_many == 0
  end
  
  def are_more_than?(n)
    how_many > n
  end
  
  def are_at_least?(n)
    how_many >= n
  end
  
  def are_at_most?(n)
    how_many <= n
  end
  
  def are_less_than?(n)
    how_many < n
  end
  
  def are_exactly?(n)
    how_many == n
  end
  
  ###################
  #                 #
  # Must Be Methods #
  #                 #
  ###################
  
  def must_be(meth = nil, &block)
    inject(true) { |so_far, item| so_far && __call(item, meth, &block) }
  end
  
  def must_not_be(meth = nil, &block)
    inject(true) { |so_far, item| so_far && ! __call(item, meth, &block) }
  end
  
  def some_must_be(meth = nil, &block)
    inject(false) { |so_far, item| so_far || __call(item, meth, &block) }
  end
  
  def must_be_only(obj)
    are_exactly?(1) && the_first == obj
  end
  
  ##################
  #                #
  # Helper Methods #
  #                #
  ##################
  
  def random
    random_index = rand how_many
    
    @set.each.with_index { |item, index| return item if index == random_index }
  end

  protected
  
    def set
      @set
    end
  
  private

    def __call(item, meth, *args, &block)
      if meth.kind_of?(String) || meth.kind_of?(Symbol)
        item.send(meth, *args)
      elsif meth.kind_of?(Proc)
        meth.(item)
      elsif block_given?
        yield item
      end
    end

    def another(of = nil)
      self.class.new(of)
    end

end
