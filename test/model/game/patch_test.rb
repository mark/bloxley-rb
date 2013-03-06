describe Bloxley::Patch do
  
  let(:patch_controller) { mock('patch controller') }

  subject { Bloxley::Patch.new patch_controller, :foo, bar: :baz }
  
  describe :initialize do
  
    it "should know the provided patch controller" do
      subject.patch_controller.must_equal patch_controller
    end
    
    it "should know the provided key" do
      subject.is_a(:foo).must_equal true
    end
    
    it "should know the provided info" do
      subject[:bar].must_equal :baz
    end

  end

  describe :attach do

    before do
      subject.attach "GAMEBOARD", 99, 101
    end

    it "should know the board it is attached to" do
      subject.board.must_equal "GAMEBOARD"
    end

    it "should know the x and y coordinates it is attached to" do
      subject.x.must_equal 99
      subject.y.must_equal 101
    end

  end

  describe :in_direction do

    before do
      subject.attach gameboard, 0, 10
    end

    let(:gameboard) do
      mock('gameboard').tap do |board|
        board.stubs(:patch_at).with(1, 12).returns(:foo)
        board.stubs(:patch_at).with(2, 14).returns(:bar)
      end
    end

    let(:direction) { stub(dx: 1, dy: 2) }

    it "should return the patch at (1, 12) when steps is not provided" do
      subject.in_direction(direction).must_equal :foo
    end


    it "should return the patch at (2, 14) when steps is 2" do
      subject.in_direction(direction, 2).must_equal :bar
    end

  end

  describe :key do

    it "should return the key passed in at construction" do
      subject.key.must_equal :foo
    end

    it "should return the key that is set" do
      subject.key = :bar
      subject.key.must_equal :bar
    end

  end

  describe :is_a do

    it "should match for the key passed in at construction" do
      subject.is_a(:foo).must_equal true
    end

    it "should not match for other keys" do
      subject.is_a(:bar).must_equal false
    end

    it "should match for the key that is set" do
      subject.key = :bar
      subject.is_a(:bar).must_equal true
    end

  end

  describe :isnt_a do

    it "shouldn't match for the key passed in at construction" do
      subject.isnt_a(:foo).must_equal false
    end

    it "should match for other keys" do
      subject.isnt_a(:bar).must_equal true
    end

    it "shouldn't match for the key that is set" do
      subject.key = :bar
      subject.isnt_a(:bar).must_equal false
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

  describe "event methods" do

    subject { Bloxley::Patch.new controller, :foo }

    let(:action)     { mock('action') }
    let(:actor)      { mock('actor') }
    let(:controller) { mock('controller') }
    let(:enter)      { mock('enter') }
    let(:exit)       { mock('exit') }

    it "passes enter events onto the controller" do
      controller.expects(:resolve_event)
                .with(action, :enter, actor, subject)
                .returns(enter)

      subject.enter_event(action, actor).must_equal enter
    end

    it "passes exit events onto the controller" do
      controller.expects(:resolve_event)
                .with(action, :exit, actor, subject)
                .returns(exit)

      subject.exit_event(action, actor).must_equal exit
    end

  end

end
