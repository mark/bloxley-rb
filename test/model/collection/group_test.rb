describe Bloxley::Group do

  def mock_actor(region)
    mock("actor").tap do |obj|
      obj.stubs(where_am_i: region)
    end
  end

  def mock_player(*options)
    mock("actor").tap do |obj|
      [:active?, :can_be_player?, :good?].each do |meth|
        obj.stubs(meth => options.include?(meth))
      end
    end
  end

  describe "that_are_at / that_are_not_at" do

    let(:actor_1) { mock_actor(region_with_patch)    }
    let(:actor_2) { mock_actor(region_without_patch) }
    let(:actor_3) { mock_actor(region_with_patch)    }
    let(:actor_4) { mock_actor(region_without_patch) }

    let(:patch) { mock('patch') }

    let(:region_with_patch) { Bloxley::Region.new(patch) }
    let(:region_without_patch) { Bloxley::Region.new() }

    subject { Bloxley::Group.new [actor_1, actor_2, actor_3, actor_4] }
    
    it 'that_are_at should return actors on the patch' do
      result = subject.that_are_at(patch)

      result.how_many.must_equal 2
      result.contains?(actor_1).must_equal true
      result.contains?(actor_3).must_equal true
    end

    it 'that_are_at should not return actors not on the patch' do
      result = subject.that_are_at(patch)

      result.contains?(actor_2).must_equal false
      result.contains?(actor_4).must_equal false
    end

    it 'that_are_not_at should not return the actors on that patch' do
      result = subject.that_are_not_at(patch)

      result.contains?(actor_1).must_equal false
      result.contains?(actor_3).must_equal false
    end

    it 'that_are_not_at should return the actors not on that' do
      result = subject.that_are_not_at(patch)

      result.how_many.must_equal 2
      result.contains?(actor_2).must_equal true
      result.contains?(actor_4).must_equal true
    end

  end

  describe "that_are_in / that_are_not_in" do

    let(:actor_1) { mock_actor(region_disjoint)      }
    let(:actor_2) { mock_actor(region_distinct)      }
    let(:actor_3) { mock_actor(region_proper_subset) }
    let(:actor_4) { mock_actor(region_subset)        }

    let(:region_disjoint)      { Bloxley::Region.new([1, 2, 6]) }
    let(:region_distinct)      { Bloxley::Region.new([4, 5, 6]) }
    let(:region_proper_subset) { Bloxley::Region.new([2, 3])    }
    let(:region_subset)        { Bloxley::Region.new([1, 2, 3]) }
    let(:region_test)          { Bloxley::Region.new([1, 2, 3]) }

    subject { Bloxley::Group.new [actor_1, actor_2, actor_3, actor_4] }
    
    it "that_are_in should include actors that are in the region" do
      result = subject.that_are_in(region_test)

      result.how_many.must_equal 3
      result.contains?(actor_1).must_equal true
      result.contains?(actor_3).must_equal true
      result.contains?(actor_4).must_equal true
    end

    it "that_are_in should not include actors that are not in the region" do
      result = subject.that_are_in(region_test)

      result.contains?(actor_2).must_equal false
    end

    it "that_are_not_in should not include actors that are in the region" do
      result = subject.that_are_not_in(region_test)

      result.contains?(actor_1).must_equal false
      result.contains?(actor_3).must_equal false
      result.contains?(actor_4).must_equal false
    end

    it "that_are_not_in should include actors that are not in the region" do
      result = subject.that_are_not_in(region_test)

      result.how_many.must_equal 1
      result.contains?(actor_2).must_equal true
    end

  end

  describe "that_are_within / that_are_not_within" do

    let(:actor_1) { mock_actor(region_disjoint)      }
    let(:actor_2) { mock_actor(region_distinct)      }
    let(:actor_3) { mock_actor(region_proper_subset) }
    let(:actor_4) { mock_actor(region_subset)        }

    let(:region_disjoint)      { Bloxley::Region.new([1, 2, 6]) }
    let(:region_distinct)      { Bloxley::Region.new([4, 5, 6]) }
    let(:region_proper_subset) { Bloxley::Region.new([2, 3])    }
    let(:region_subset)        { Bloxley::Region.new([1, 2, 3]) }
    let(:region_test)          { Bloxley::Region.new([1, 2, 3]) }

    subject { Bloxley::Group.new [actor_1, actor_2, actor_3, actor_4] }
    
    it "that_are_within should include actors that are in the region" do
      result = subject.that_are_within(region_test)

      result.how_many.must_equal 2
      result.contains?(actor_3).must_equal true
      result.contains?(actor_4).must_equal true
    end

    it "that_are_within should not include actors that are not in the region" do
      result = subject.that_are_within(region_test)

      result.contains?(actor_1).must_equal false
      result.contains?(actor_2).must_equal false
    end

    it "that_are_not_within should not include actors that are in the region" do
      result = subject.that_are_not_within(region_test)

      result.contains?(actor_3).must_equal false
      result.contains?(actor_4).must_equal false
    end

    it "that_are_not_within should include actors that are not in the region" do
      result = subject.that_are_not_within(region_test)

      result.how_many.must_equal 2
      result.contains?(actor_1).must_equal true
      result.contains?(actor_2).must_equal true
    end

  end

  describe "that_are_active / that_are_not_active" do

    let(:active_player)   { mock_player(:active?)  }
    let(:inactive_player) { mock_player()          }

    subject { Bloxley::Group.new [active_player, inactive_player] }

    it "that_are_active should return active actors" do
      result = subject.that_are_active

      result.how_many.must_equal 1
      result.contains?(active_player).must_equal true
    end

    it "that_are_active should not return inactive players" do
      result = subject.that_are_active

      result.contains?(inactive_player).must_equal false
    end

    it "that_are_not_active should not return active actors" do
      result = subject.that_are_not_active

      result.contains?(active_player).must_equal false
    end

    it "that_are_not_active should return inactive players" do
      result = subject.that_are_not_active

      result.how_many.must_equal 1
      result.contains?(inactive_player).must_equal true
    end

  end

  describe :that_can_be_player do

    let(:actor_1) { mock_player() }
    let(:actor_2) { mock_player(:can_be_player?)  }
    let(:actor_3) { mock_player(:active?) }
    let(:actor_4) { mock_player(:active?, :can_be_player?)  }

    subject { Bloxley::Group.new [actor_1, actor_2, actor_3, actor_4] }

    it "should return units that are active, and can be player" do
      result = subject.that_can_be_player

      result.how_many.must_equal 1
      result.contains?(actor_4).must_equal true
    end
    
    it "should not return units that are not active or can't be player" do
      result = subject.that_can_be_player

      result.contains?(actor_1).must_equal false
      result.contains?(actor_2).must_equal false
      result.contains?(actor_3).must_equal false
    end

  end

  describe :are_all_good do

    let(:good_actor_1) { mock_player(:good?) }
    let(:good_actor_2) { mock_player(:good?) }
    let(:bad_actor)    { mock_player()       }

    it "should return true when all of the actors are good" do
      group = Bloxley::Group.new [good_actor_1, good_actor_2]

      group.are_all_good?.must_equal true
    end

    it "should return false when not all of the actors are good" do
      group = Bloxley::Group.new [good_actor_1, good_actor_2, bad_actor]

      group.are_all_good?.must_equal false
    end

    it "should return false when there are no actors" do
      group = Bloxley::Group.new

      group.are_all_good?.must_equal false
    end


  end


end
