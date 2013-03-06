describe Bloxley::Board do

  describe :constructor do
    
    subject { Bloxley::Board.new(:game) }
    
    it "should exist" do
      subject.wont_be_nil
    end

    it "should be a board" do
      subject.must_be_kind_of Bloxley::Board
    end

    it "should properly store the passed in game" do
      subject.instance_variable_get("@game").must_equal :game
    end
  end
  
  describe :attach_patch do

    subject { Bloxley::Board.new(nil) }

    def mock_patch
      mock('patch').tap do |patch|
        patch.stubs(:attach)
      end
    end

    it "should complain if you try to place the patch in an illegal place" do
      ->() { subject.attach_patch mock_patch, -1, -1 }.must_raise ArgumentError
    end

    it "should attach tell the patch it is added" do
      patch = mock_patch
      patch.expects(:attach).with(subject, 2, 3)

      subject.attach_patch patch, 2, 3
    end

    it "should increase the board to contain it" do
      subject.attach_patch mock_patch, 2, 3

      subject.height.must_be :>=, 2
      subject.width.must_be  :>=, 3
    end

    it "should be accessible at the given point" do
      patch = mock_patch

      subject.attach_patch patch, 2, 3

      subject.patch_at(2, 3).must_equal patch
    end

    it "should be added to the board's region" do
      patch = mock_patch

      subject.attach_patch patch, 2, 3

      subject.region.contains?(patch).must_equal true
    end
  end

  describe :clear_patches do

    subject { Bloxley::Board.new nil }
    
    it "should destroy existing patches" do
      patch = mock('object')
      patch.expects(:destroy)
      subject.instance_variable_set "@patches", [patch]
      
      subject.clear_patches
    end
    
    it "should return existing patches" do
      patches = stub each: nil      
      subject.instance_variable_set "@patches", patches
      
      subject.clear_patches.must_equal patches
    end
    
    it "should set height and width to 0" do
      subject.instance_variable_set "@height", :foo
      subject.instance_variable_set "@width",  :bar
      
      subject.clear_patches
      
      subject.height.must_equal 0
      subject.width .must_equal 0
    end
    
    it "should set patches to empty array" do
      patches = stub each: nil      
      subject.instance_variable_set "@patches", patches
      
      subject.clear_patches
      
      subject.instance_variable_get("@patches").must_equal []
    end
    
  end

  describe :on_board do

    subject do
      Bloxley::Board.new(nil).tap do |board|
        board.set_dimensions 3, 5
      end
    end

    it "should return true for locations on board" do
      subject.on_board?(2, 2).must_equal true
    end

  end

  
end
