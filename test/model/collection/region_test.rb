describe Bloxley::Region do
  
  def mock_patch(board, x = 0, y = 0)
    mock('patch').tap do |patch|
      patch.stubs(board: board, x: x, y: y)
    end
  end

  let(:board) { mock('board') }

  describe :board do

    it "should return the board of one of the patches" do
      region = Bloxley::Region.new [ mock_patch(board), mock_patch(board), mock_patch(board) ]

      region.board.must_equal board
    end

  end

  describe :in_direction do

    it "should shift the region" do
      board = test_board(3, 3)

      region = Bloxley::Region.new [ board.patch_at(0, 0),
                                     board.patch_at(1, 0) ]

      direction = mock('direction')
      direction.stubs(dx: 1, dy: 2)

      result = region.in_direction(direction)

      result.how_many.must_equal 2
      result.contains?(board.patch_at(1, 2)).must_equal true
      result.contains?(board.patch_at(2, 2)).must_equal true 
    end

  end

  describe :overlaps do
    let(:set_1) { Bloxley::Region.new [1, 2, 3] }
    let(:set_2) { Bloxley::Region.new [2, 4, 5] }
    let(:set_3) { Bloxley::Region.new [4, 5, 6] }

    it "should return true when there is an intersection" do
      set_1.overlaps?(set_2).must_equal true
    end

    it "should return false when there is no intersection" do
      set_1.overlaps?(set_3).must_equal false
    end

  end

  describe :contained_in do

    let(:set_1) { Bloxley::Region.new [1, 2, 3] }
    let(:set_2) { Bloxley::Region.new [2, 3] }
    let(:set_3) { Bloxley::Region.new [4, 5, 6] }
    let(:set_4) { Bloxley::Region.new [1, 2, 3, 4] }

    it "should return false when there is an intersection" do
      set_1.contained_in?(set_2).must_equal false
    end

    it "should return false when there is no intersection" do
      set_1.contained_in?(set_3).must_equal false
    end

    it "should return true when it is completely contained" do
      set_1.contained_in?(set_4).must_equal true
    end

    it "should return true when they are the same" do
      set_1.contained_in?(set_1).must_equal true
    end

  end

  describe :bounds do

    it "should show the location of the only patch if there is one" do
      reg = Bloxley::Region.new [ mock_patch(:board, 3, 4) ]
      reg.bounds.must_equal( { left: 3, right: 3, top: 4, bottom: 4 })
    end

    it "should contain the bounds of the patches inside" do
      reg = Bloxley::Region.new [ mock_patch(:board, 3, 4),
                                  mock_patch(:board, 5, 2) ]
      reg.bounds.must_equal( { left: 3, right: 5, top: 2, bottom: 4 })
    end

  end

end