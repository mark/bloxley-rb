require 'minitest/spec'
require 'minitest/autorun'
require "mocha/setup"

require_relative '../lib/bloxley'

def test_board(w, h)
  Bloxley::Board.new(nil).tap do |board|
    w.times do |x|
      h.times do |y|
        patch = Bloxley::Patch.new(nil, :foo)
        board.attach_patch(patch, x, y)
      end
    end
  end
end
