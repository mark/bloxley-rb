describe Bloxley::PatchController do

  subject { Bloxley::PatchController.new game }

  let(:game) { mock('game') }

  let(:successful_action) do
    mock('action').tap do |action|
      action.expects(:succeed)
    end
  end

  describe :constructor do

    it "should save the key" do
      subject.key.must_equal "Patch"
    end

    it "should save the game" do
      subject.game.must_equal game
    end
    
  end

  describe :animator_for do

    it "should return a patch animator" do
      subject.animator_for(:foo).must_be_kind_of Bloxley::PatchAnimator
    end

  end

  describe :can_enter do

    it "should make the action succeed" do
      subject.can_enter(successful_action, :source, :target)
    end

  end

  describe :can_exit do

    it "should make the action succeed" do
      subject.can_exit(successful_action, :source, :target)
    end

  end

  describe :create_patch do

    before do
      subject.stubs(library: library)
    end

    let(:char) { "char" }

    let(:library) do
      mock('tile library').tap do |lib|
        lib.stubs(key_for_tile: "foo")
      end
    end

    it "should get the key from the tile library" do
      library.expects(:key_for_tile).with(char)

      subject.create_patch(char)
    end

    it "should create a patch with the right info" do
      patch = subject.create_patch(char)

      patch.key.must_equal "foo"
      patch.patch_controller.must_equal subject
      patch[:tile].must_equal char
    end

    it "should set up the patch" do
      patch = mock('patch')

      Bloxley::Patch.stubs(new: patch)

      subject.expects(:setup).with(patch)

      subject.create_patch(char)
    end

  end

  describe :illustrator_for do

    it "should return a patch illustrator" do
      subject.illustrator_for(:foo).must_be_kind_of Bloxley::PatchIllustrator
    end

  end

  describe :library do

    it "should return a tile library" do
      subject.library.must_be_kind_of Bloxley::TileLibrary
    end

  end

  describe :resolve_event do

    let(:action) { mock('action') }

    let(:source) do
      mock('source').tap do |s|
        s.stubs(key: "source_key")
      end
    end

    let(:target) do
      mock('target').tap do |t|
        t.stubs(key: "target_key")
      end
    end

    it "should work for enter events" do
      subject.expects(:can_enter).with(action, source, target)

      subject.resolve_event action, :enter, source, target
    end

    it "should work for exit events" do
      subject.expects(:can_exit).with(action, source, target)

      subject.resolve_event action, :exit, source, target
    end

    it "should call s_e_t over e_t" do
      def subject.can_source_key_enter_target_key; end
      def subject.can_enter_target_key; end

      subject.expects(:can_source_key_enter_target_key)
      subject.expects(:can_enter_target_key).never

      subject.resolve_event action, :enter, source, target
    end

    it "should call s_e_t over s_e" do
      def subject.can_source_key_enter_target_key; end
      def subject.can_source_key_enter; end

      subject.expects(:can_source_key_enter_target_key)
      subject.expects(:can_source_key_enter).never

      subject.resolve_event action, :enter, source, target
    end

    it "should call s_e_t over e" do
      def subject.can_source_key_enter_target_key; end

      subject.expects(:can_source_key_enter_target_key)
      subject.expects(:can_enter).never

      subject.resolve_event action, :enter, source, target
    end

    it "should call e_t over s_e" do
      def subject.can_enter_target_key; end
      def subject.can_source_key_enter; end

      subject.expects(:can_enter_target_key)
      subject.expects(:can_source_key_enter).never

      subject.resolve_event action, :enter, source, target
    end

    it "should call e_t over e" do
      def subject.can_enter_target_key; end

      subject.expects(:can_enter_target_key)
      subject.expects(:can_enter).never

      subject.resolve_event action, :enter, source, target
    end

    it "should call s_e over e" do
      def subject.can_source_key_enter; end

      subject.expects(:can_source_key_enter)
      subject.expects(:can_enter).never

      subject.resolve_event action, :enter, source, target
    end

  end

  describe :setup do
    # This is a no-op
  end

  describe :sprite_for do

    it "should return the stored sprite" do
      patch  = mock('patch')
      sprite = mock('sprite')

      subject.instance_variable_set "@sprites", { patch => sprite }

      subject.sprite_for(patch).must_equal sprite
    end

  end

  describe :tile do

    let(:chars) { "chars" }
    let(:frame) { "frame" }
    let(:key)   { "key"   }

    it "should add a tile with the provided info" do
      subject.library.expects(:add_tile).with(key, chars, frame)

      subject.tile key, chars, frame
    end

    it "should allow frame to not be passed in" do
      subject.library.expects(:add_tile).with(key, chars, nil)

      subject.tile key, chars
    end

  end

  describe :tiles do

    let(:hash) do
      { key1: "chars1", key2: "chars2", key3: "chars3" }
    end

    it "should call tile with each key/value pair" do
      hash.each do |k, v|
        subject.expects(:tile).with(k, v)
      end

      subject.tiles hash
    end

  end

end
