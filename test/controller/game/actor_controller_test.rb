describe Bloxley::ActorController do

  subject { Bloxley::ActorController.new game, "actor" }

  let(:actor) { mock('actor') }

  let(:game) { mock('game') }

  describe :constructor do

    it "should save the game" do
      subject.game.must_equal game
    end

    it "should save the key" do
      subject.key.must_equal "actor"
    end

  end

  describe :actor_can_be_player? do

    it "should default to false" do
      subject.actor_can_be_player?(actor).must_equal false
    end

  end

  describe :actor_good? do

    it "should default to false" do
      subject.actor_good?(actor).must_equal false
    end

  end

  describe :create_actor do


  end

end