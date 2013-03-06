require_relative 'set'

class Bloxley::Region < Bloxley::Set

  def initialize(obj = nil)
    super

    @valid = true
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def board
    the_first.board
  end

  def insert(patch)
    if patch
      super
    else
      @valid = false
    end
  end

  def in_direction(direction)
    map { |patch| patch.in_direction(direction) }
  end

  def is_valid?
    @valid
  end

  def overlaps?(other)
    intersection(other).are_there_any?
  end

  def contained_in?(other)
    intersection(other).how_many == how_many
  end

  def bounds
    bound = { left: the_first.x, right:  the_first.x,
              top: the_first.y,  bottom: the_first.y }

    each do |patch|
      bound[:left]   = min patch.x, bound[:left]
      bound[:right]  = max patch.x, bound[:right]
      bound[:top]    = min patch.y, bound[:top]
      bound[:bottom] = max patch.y, bound[:bottom]
    end

    bound
  end

end
