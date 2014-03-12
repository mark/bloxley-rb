describe Bloxley::TileLibrary do

  let(:other_tile) { Bloxley::Tile.new('other_key', 'efgh', 'other_frame') }

  let(:tile) { Bloxley::Tile.new('key', 'abcd', 'frame') }

  subject { Bloxley::TileLibrary.new([]) }

  describe :constructor do

  end

  describe :add_tile do

    it "should save the tile by the key" do
      subject.add_tile tile
      subject.tile_for_key('key').must_equal tile
    end

    it "should not return when it's not the key" do
      subject.add_tile tile
      subject.tile_for_key('other_key').wont_equal tile
    end
  end

  describe :default_key do

    it "should return the only key" do
      subject.add_tile tile
      subject.default_key.must_equal 'key'
    end

    it "should return the first key" do
      subject.add_tile tile
      subject.add_tile other_tile
      subject.default_key.must_equal 'key'
    end

    it "shoudn't return the second key" do
      subject.add_tile tile
      subject.add_tile other_tile
      subject.default_key.wont_equal 'other_key'
    end

  end

  describe :key_for_tile do

    # before { subject}
    
    it "should return default key if no string is passed in" do

    end

  end

end
