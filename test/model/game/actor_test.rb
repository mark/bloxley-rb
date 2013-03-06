describe Bloxley::Actor do

  subject { Bloxley::Actor.new actor_controller, :foo, bar: :baz }

  let(:actor_controller) do
    mock('actor controller').tap do |actor|
      actor.stubs(:setup_actor)
    end
  end

  let(:patch) { mock('patch') }

  describe :constructor do

    it "should know the provided actor controller" do
      subject.actor_controller.must_equal actor_controller
    end

    it "should know the provided key" do
      subject.key.must_equal :foo
    end

    it "should know the provided info" do
      subject[:bar].must_equal :baz
    end

    it "should be active" do
      subject.active?.must_equal true
    end

    it "should have the controller setup the actor" do
      actor_controller.expects(:setup_actor).with(subject)
    end

  end
  
  describe "[] and []=" do

    it "should find the info passed in at construction" do
      subject[:bar].must_equal :baz
    end

    it "should find the info that's set later" do
      subject[:bar] = :quux
      subject[:bar].must_equal :quux
    end    

  end

  describe :attach do

    before do
      subject.stubs(:place_at)
    end

    let(:board) { mock('board') }

    it "should know the provided board" do
      subject.attach board
      subject.board.must_equal board
    end

    it "shouldn't call place_at if patch isn't provided" do
      subject.expects(:place_at).never
      subject.attach board
    end

    it "should call place_at if patch is provided" do
      subject.expects(:place_at).with(patch)
      subject.attach board, patch
    end

  end

  describe :place_at do

    it "should have a region that contains that patch" do
      actor_controller.stubs(region_for_actor_at_location: Bloxley::Region.new(patch))
      subject.place_at patch
      subject.where_am_i.must_be_only(patch)
    end

  end

  describe :where_am_i do

    let(:region) { mock('region') }

    it "should ask the controller" do
      actor_controller.expects(:region_for_actor_at_location).with(subject, patch)
      subject.instance_variable_set '@anchor_point', patch

      subject.where_am_i
    end

    it "should return the result" do
      actor_controller.stubs(region_for_actor_at_location: region)

      subject.where_am_i.must_equal region
    end

    it "should cache the result" do
      actor_controller.expects(:region_for_actor_at_location).once.returns(region)

      subject.where_am_i.must_equal region
      subject.where_am_i.must_equal region
    end

  end

  describe :am_i_at? do

    before do
      subject.stubs(where_am_i: region)
    end

    let(:bad_patch) { mock('bad patch')}

    let(:good_patch) { mock('good patch') }

    let(:other_patch) { mock('other patch')}

    let(:region) { Bloxley::Region.new [good_patch, other_patch] }

    it "returns true if the current region contains the provided patch" do
      subject.am_i_at?(good_patch).must_equal true
    end

    it "returns false if the current region doesn't contains the provided patch" do
      subject.am_i_at?(bad_patch).must_equal false
    end

  end

  describe :am_i_in? do

    before do
      subject.stubs(where_am_i: region)
    end

    let(:bad_region)  { Bloxley::Region.new [patch_3, patch_4] }

    let(:good_region) { Bloxley::Region.new [patch_2, patch_3] }

    let(:patch_1) { mock('patch 1') }

    let(:patch_2) { mock('patch 2') }

    let(:patch_3) { mock('patch 3') }

    let(:patch_4) { mock('patch 4') }

    let(:region) { Bloxley::Region.new [patch_1, patch_2] }

    it "returns true if the current region overlaps the provided region" do
      subject.am_i_in?(good_region).must_equal true
    end

    it "returns false if the current region doesn't overlap the provided region" do
      subject.am_i_in?(bad_region).must_equal false
    end

  end

  describe :am_i_within? do
    
    before do
      subject.stubs(where_am_i: region)
    end

    let(:bad_region)  { Bloxley::Region.new [patch_2, patch_3] }

    let(:good_region) { Bloxley::Region.new [patch_1, patch_2, patch_3] }

    let(:patch_1) { mock('patch 1') }

    let(:patch_2) { mock('patch 2') }

    let(:patch_3) { mock('patch 3') }

    let(:region) { Bloxley::Region.new [patch_1, patch_2] }

    it "returns true if the provided region contains the current region" do
      subject.am_i_within?(good_region).must_equal true
    end

    it "returns true if the provided region equals the current region" do
      subject.am_i_within?(region).must_equal true
    end

    it "returns false if the current region merely overlaps the provided region" do
      subject.am_i_within?(bad_region).must_equal false
    end

  end

  describe :am_i_standing_on? do

    def mock_patch(key)
      Bloxley::Patch.new(nil, key)
    end

    let(:good_region) { Bloxley::Region.new [mock_patch('foo'), mock_patch('foo')] }

    let(:bad_region) { Bloxley::Region.new [mock_patch('foo'), mock_patch('bar')] }

    it "should return true if all patches are of the given type" do
      subject.stubs(where_am_i: good_region)

      subject.am_i_standing_on?('foo').must_equal true
    end

    it "should return false if not all patches are of the given type" do
      subject.stubs(where_am_i: bad_region)

      subject.am_i_standing_on?('foo').must_equal false
    end

  end


end