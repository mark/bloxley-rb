describe Bloxley::Set do

  # Helpers:
  
  class DummySet < Bloxley::Set; end
  
  def mock_foo(ret)
    mock('object').tap do |obj|
      obj.expects(:foo).returns(ret)
    end
  end

  # Tests:
  
  subject { Bloxley::Set.new [:foo, :bar, :baz] }

  describe "constructor" do
    it "should contain the element passed in to the constructor" do
      set = Bloxley::Set.new :foo
      
      set.contains?(:foo).must_equal true
      set.how_many.must_equal 1
    end
    
    it "should't contain an element not passed in to the constructor" do
      set = Bloxley::Set.new :foo
      
      set.contains?(:bar).must_equal false
    end
    
    it "should contain all elements passed in to the constructor" do
      set = Bloxley::Set.new [:foo, :bar]
      
      set.contains?(:foo).must_equal true
      set.contains?(:bar).must_equal true
      set.how_many.must_equal 2
    end
  end
  
  describe :insert do
  
    it "should insert a new object" do
      subject.insert :quux
      
      subject.contains?(:quux).must_equal true
      subject.how_many.must_equal 4
    end
    
    it "should not insert a duplicate" do
      subject.insert :baz
      
      subject.how_many.must_equal 3
    end
    
    it "should not insert nil" do
      subject.insert nil
      
      subject.how_many.must_equal 3
      subject.contains?(nil).wont_equal true
    end
    
  end
  
  describe :remove do
  
    it "should remove an object that's present" do
      subject.remove :baz
      
      subject.how_many.must_equal 2
      subject.contains?(:baz).wont_equal true
    end
    
    it "should not remove an object that's not present" do
      subject.remove :quux
      
      subject.how_many.must_equal 3
    end

    it "should return the object removed" do
      subject.remove(:baz).must_equal :baz
    end
    
    it "should return nil if no object is removed" do
      subject.remove(:quux).must_equal nil
    end
    
  end
  
  describe :contains? do
    
    it "should contain elements that are there when created" do
      set = Bloxley::Set.new :foo
      
      set.contains?(:foo).must_equal true
    end
    
    it "should contain elements that are added" do
      set = Bloxley::Set.new      
      set.insert(:foo)

      set.contains?(:foo).must_equal true
    end

    it "should not contain elements that are not there" do
      set = Bloxley::Set.new :foo
      
      set.contains?(:bar).must_equal false
    end
    
  end
  
  describe :union do
    
    let(:set_1) { Bloxley::Set.new [ :foo, :bar ] }
    let(:set_2) { Bloxley::Set.new [ :bar, :baz ] }
    
    subject { set_1.union set_2 }
    
    it "should include all elements in either set" do
      subject.how_many.must_equal 3
      
      subject.contains?(:foo).must_equal true
      subject.contains?(:bar).must_equal true
      subject.contains?(:baz).must_equal true
    end
    
  end
  
  describe :intersection do

    let(:set_1) { Bloxley::Set.new [ :foo, :bar ] }
    let(:set_2) { Bloxley::Set.new [ :bar, :baz ] }
    
    subject { set_1.intersection set_2 }
    
    it "should include all elements in both sets" do
      subject.how_many.must_equal 1
      
      subject.contains?(:foo).must_equal false
      subject.contains?(:bar).must_equal true
      subject.contains?(:baz).must_equal false
    end
    
  end
  
  describe :minus do

    let(:set_1) { Bloxley::Set.new [ :foo, :bar ] }
    let(:set_2) { Bloxley::Set.new [ :bar, :baz ] }
    
    subject { set_1.minus set_2 }
    
    it "should include all elements in the first set but not the second" do
      subject.how_many.must_equal 1
      
      subject.contains?(:foo).must_equal true
      subject.contains?(:bar).must_equal false
      subject.contains?(:baz).must_equal false
    end  
  
  end
  
  describe "counting methods" do

    let(:set_with_no_elements   ) { Bloxley::Set.new }
    let(:set_with_one_element   ) { Bloxley::Set.new :foo }
    let(:set_with_three_elements) { Bloxley::Set.new %w(foo bar baz) }
    
    it "should know how many are in there" do
      set_with_no_elements   .how_many.must_equal 0
      set_with_one_element   .how_many.must_equal 1
      set_with_three_elements.how_many.must_equal 3
    end
    
    it "should know if there are any in there" do
      set_with_no_elements   .are_there_any?.must_equal false
      set_with_one_element   .are_there_any?.must_equal true
      set_with_three_elements.are_there_any?.must_equal true
    end
    
    it "should know if there are none in there" do
      set_with_no_elements   .is_empty?.must_equal true
      set_with_one_element   .is_empty?.must_equal false
      set_with_three_elements.is_empty?.must_equal false
    end

    it "should know if there are none in there" do
      set_with_no_elements   .is_empty?.must_equal true
      set_with_one_element   .is_empty?.must_equal false
      set_with_three_elements.is_empty?.must_equal false
    end

    it "should know if there are more than" do
      set_with_three_elements.are_more_than?(2).must_equal true
      set_with_three_elements.are_more_than?(3).must_equal false
      set_with_three_elements.are_more_than?(4).must_equal false
    end

    it "should know if there are at least" do
      set_with_three_elements.are_at_least?(2).must_equal true
      set_with_three_elements.are_at_least?(3).must_equal true
      set_with_three_elements.are_at_least?(4).must_equal false
    end

    it "should know if there are at most" do
      set_with_three_elements.are_at_most?(2).must_equal false
      set_with_three_elements.are_at_most?(3).must_equal true
      set_with_three_elements.are_at_most?(4).must_equal true
    end
    
    it "should know if there are less than" do
      set_with_three_elements.are_less_than?(2).must_equal false
      set_with_three_elements.are_less_than?(3).must_equal false
      set_with_three_elements.are_less_than?(4).must_equal true
    end
    
    it "should know if there are at exactly" do
      set_with_three_elements.are_exactly?(2).must_equal false
      set_with_three_elements.are_exactly?(3).must_equal true
      set_with_three_elements.are_exactly?(4).must_equal false
    end
    
  end
  
  describe :must_be do
  
    it "should return true if it is true for every element" do
      set = Bloxley::Set.new [ stub(foo: true), stub(foo: true) ]
      set.must_be('foo').must_equal true
    end
    
    it "should return false if it is not true for any element" do
      set = Bloxley::Set.new [ stub(foo: true), stub(foo: false) ]
      set.must_be('foo').must_equal false
    end
    
  end

  describe :must_not_be do
  
    it "should return true if it is not true for every element" do
      set = Bloxley::Set.new [ stub(foo: false), stub(foo: false) ]
      set.must_not_be('foo').must_equal true
    end
    
    it "should return false if it is true for any element" do
      set = Bloxley::Set.new [ stub(foo: true), stub(foo: false) ]
      set.must_not_be('foo').must_equal false
    end
    
  end

  describe :some_must_be do
  
    it "should return true if it is true for any element" do
      set = Bloxley::Set.new [ stub(foo: true), stub(foo: false) ]
      set.some_must_be('foo').must_equal true
    end
    
    it "should return false if it is not true for every element" do
      set = Bloxley::Set.new [ stub(foo: false), stub(foo: false) ]
      set.some_must_be('foo').must_equal false
    end
    
  end
  
  describe :must_be_only? do
  
    it "should return false if the set is empty" do
      set = Bloxley::Set.new
      set.must_be_only(:foo).must_equal false
    end
    
    it "should return true if the set has just that element" do
      set = Bloxley::Set.new :foo
      set.must_be_only(:foo).must_equal true
    end

    it "should return false if the set has a different element" do
      set = Bloxley::Set.new :bar
      set.must_be_only(:foo).must_equal false
    end
    
    it "should return false if the set has multiple elements" do
      set = Bloxley::Set.new [ :foo, :bar ]
      set.must_be_only(:foo).must_equal false
    end

  end
  
  describe :each do

    subject do
      items = [ mock('object'), mock('object') ]
      items.each { |item| item.expects(:foo) }
      
      Bloxley::Set.new items
    end
    
    it "should call the specified method passed as a symbol on all objects" do
      subject.each :foo
    end

    it "should call the specified method when called in a lambda" do
      subject.each ->(item) { item.foo }
    end
    
    it "should call the specified method when called in the block" do
      subject.each { |item| item.foo }
    end
    
  end
  
  describe :select do
    
    subject do
      Bloxley::Set.new [ mock_foo(true), mock_foo(false), mock_foo(true) ]
    end
    
    it "should return a Bloxley::Set" do
      subject.select(:foo).must_be_kind_of Bloxley::Set
    end

    it "should return a subclass instance when called on a subclass instance" do
      DummySet.new.select.must_be_kind_of DummySet
    end

    it "should call the specified method passed as a symbol on all objects" do
      subject.select(:foo).how_many.must_equal 2
    end

    it "should call the specified method when called in a lambda" do
      subject.select(->(item) { item.foo }).how_many.must_equal 2
    end
    
    it "should call the specified method when called in the block" do
      subject.select { |item| item.foo }.how_many.must_equal 2
    end
    
  end

  describe :that_are do
    
    subject do
      Bloxley::Set.new [ mock_foo(true), mock_foo(false), mock_foo(true) ]
    end
    
    it "should return a Bloxley::Set" do
      subject.that_are(:foo).must_be_kind_of Bloxley::Set
    end

    it "should return a subclass instance when called on a subclass instance" do
      DummySet.new.that_are.must_be_kind_of DummySet
    end

    it "should call the specified method passed as a symbol on all objects" do
      subject.that_are(:foo).how_many.must_equal 2
    end

    it "should call the specified method when called in a lambda" do
      subject.that_are(->(item) { item.foo }).how_many.must_equal 2
    end
    
    it "should call the specified method when called in the block" do
      subject.that_are { |item| item.foo }.how_many.must_equal 2
    end
    
  end

  describe :reject do
    
    subject do
      Bloxley::Set.new [ mock_foo(true), mock_foo(false), mock_foo(true) ]
    end
    
    it "should return a Bloxley::Set" do
      subject.reject(:foo).must_be_kind_of Bloxley::Set
    end

    it "should return a subclass instance when called on a subclass instance" do
      DummySet.new.reject.must_be_kind_of DummySet
    end

    it "should call the specified method passed as a symbol on all objects" do
      subject.reject(:foo).how_many.must_equal 1
    end

    it "should call the specified method when called in a lambda" do
      subject.reject(->(item) { item.foo }).how_many.must_equal 1
    end
    
    it "should call the specified method when called in the block" do
      subject.reject { |item| item.foo }.how_many.must_equal 1
    end
    
  end

  describe :that_are_not do
    
    subject do
      Bloxley::Set.new [ mock_foo(true), mock_foo(false), mock_foo(true) ]
    end
    
    it "should return a Bloxley::Set" do
      subject.that_are_not(:foo).must_be_kind_of Bloxley::Set
    end

    it "should return a subclass instance when called on a subclass instance" do
      DummySet.new.that_are_not.must_be_kind_of DummySet
    end

    it "should call the specified method passed as a symbol on all objects" do
      subject.that_are_not(:foo).how_many.must_equal 1
    end

    it "should call the specified method when called in a lambda" do
      subject.that_are_not(->(item) { item.foo }).how_many.must_equal 1
    end
    
    it "should call the specified method when called in the block" do
      subject.that_are_not { |item| item.foo }.how_many.must_equal 1
    end
    
  end
  
  describe :map do
  
    subject do
      Bloxley::Set.new [ mock_foo(:bar), mock_foo(:baz) ]
    end
    
    it "should return a Bloxley::Set" do
      subject.map(:foo).must_be_kind_of Bloxley::Set
    end

    it "should return a subclass instance when called on a subclass instance" do
      DummySet.new.map.must_be_kind_of DummySet
    end

    it "should call the specified method passed as a symbol on all objects" do
      result = subject.map :foo

      result.how_many.must_equal 2
      result.contains?(:bar).must_equal true
      result.contains?(:baz).must_equal true
    end

    it "should call the specified method when called in a lambda" do
      result = subject.map ->(item) { item.foo }

      result.how_many.must_equal 2
      result.contains?(:bar).must_equal true
      result.contains?(:baz).must_equal true
    end
    
    it "should call the specified method when called in the block" do
      result = subject.map { |item| item.foo }

      result.how_many.must_equal 2
      result.contains?(:bar).must_equal true
      result.contains?(:baz).must_equal true
    end

  end
  
  describe :inject do
    
    subject do
      Bloxley::Set.new [ mock('object'), mock('object'), mock('object') ]
    end
    
    it "should return the accumulated value" do
      subject.inject(:bar) { |accum, item| accum }.must_equal :bar
    end
    
  end
  
  describe "type helpers" do
  
    it "should fetch the items with the proper key" do
      set = Bloxley::Set.new [ stub(key: :foo), stub(key: :bar), stub(key: :foo) ]
      set.of_type(:foo).how_many.must_equal 2
    end
    
    it "should fetch the items with the proper key" do
      set = Bloxley::Set.new [ stub(key: :foo), stub(key: :bar), stub(key: :foo) ]
      set.not_of_type(:foo).how_many.must_equal 1
    end
    
    it "should be true when all of the item are of provided type" do
      set = Bloxley::Set.new [ stub(key: :foo), stub(key: :foo), stub(key: :foo) ]
      set.are_all_of_type?(:foo).must_equal true
    end

    it "should be false when not all of the item are of provided type" do
      set = Bloxley::Set.new [ stub(key: :foo), stub(key: :bar), stub(key: :foo) ]
      set.are_all_of_type?(:foo).must_equal false
    end
    
  end
  
end
