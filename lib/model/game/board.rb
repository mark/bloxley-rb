class Bloxley::Board < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################

  attr_reader :height, :width, :region, :actors
  
  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(game)
    @game_is_started = false
    @game = game
    
    clear_patches
    
    @actors = Bloxley::Group.new
  end
  
  # 
  # // Clear all of the movieclips associated with this board,
  # // For when loads fail, or when we're going to load a
  # // new level.
  # public function destroy() {
  #   allPatches().each( function(patch) { patch.destroy(); } );
  # 
  #   while (allActors().areThereAny()) {
  #     allActors().theFirst().destroy();
  #   }
  # }
  # 

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################

  def clear_patches
    if @patches
      @patches.each { |patch| patch.destroy }
    end
    
    @patches.tap do
      @region  = Bloxley::Region.new
      @patches = []
      @width   = 0
      @height  = 0
    end
  end
  
  def patch_at(x, y)
    on_board?(x, y) ? @patches[y][x] : nil
  end

  def attach_patch(patch, x, y)
    raise ArgumentError, "(#{x}, #{y}) must be in NE quadrant" if x < 0 || y < 0

    @patches[y]  ||= []
    @patches[y][x] = patch

    @region.insert patch
    patch.attach self, x, y

    set_dimensions max(width,  x+1), max(height, y+1)

    # post('BXPatchAttached', patch)
  end

  def on_board?(x, y)
    x >= 0 && x < @width && y >= 0 && y < @height
  end

  def set_dimensions(width, height)
    @width  = width
    @height = height
  end
  
  def attach_actor(actor, patch)
    actors.insert(actor)
    actor.attach board, patch

    # post("BXActorAttached", actor)
  end

  # Removes the object from the objects array
  def remove_actor(actor)
    actors.remove actor
  end

  # Only the active objects on the board.  Technically, this one is called more
  # than the previous (by outside objects).
  # It may be worthwhile to keep track of these, rather than generating a new one every time?
  def active_actors
    actors.that_are(:active?)
  end

  def first_player
    actors.that_can_be_player.the_first
  end

  def next_player(current_player)
    actors.that_can_be_player.the_next_after(current_player)
  end

  #     
  #     /******************
  #     *                 *
  #     * Utility methods *
  #     *                 *
  #     ******************/
  # 
  #     // Quick string representation, for debugging.
  # override public function toString():String { return "[" + width() + "x" + height() + "]"; }
	
end
