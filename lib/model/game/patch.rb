class Bloxley::Patch < Bloxley::Base
  
  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :patch_controller, :board, :x, :y
  
  attr_accessor :key

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(controller, key, info = nil)
    @patch_controller = controller
    @key              = key
    @info             = info || {}
  end
  
  #################
  #               #
  # Event Methods #
  #               #
  #################
  
  def enter_event(action, actor)
    patch_controller.resolve_event(action, :enter, actor, self)
  end

  def exit_event(action, actor)
    patch_controller.resolve_event(action, :exit, actor, self)
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################

  def [](info_key)
    @info[info_key]
  end

  def []=(info_key, value)
    @info[info_key] = value
  end
  
  def attach(board, x, y)
    @board = board
    @x     = x
    @y     = y
  end

  def in_direction(direction, steps = 1)
    board.patch_at x + steps * direction.dx, y + steps * direction.dy
  end

  def is_a(key)
    @key == key
  end
  
  def isnt_a(key)
    ! is_a key
  end

end
