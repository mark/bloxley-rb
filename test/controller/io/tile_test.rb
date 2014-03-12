describe Bloxley::Tile do

  describe :constructor do

    it "should keep the key and the frame" do
      tile = Bloxley::Tile.new('key', 'abcd', 'frame')

      tile.key.must_equal 'key'
      tile.frame.must_equal 'frame'
    end

  end

end
