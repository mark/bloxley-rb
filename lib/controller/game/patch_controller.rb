require_relative '../../view/animation/patch_animator'
require_relative '../../view/sprite/patch_illustrator'

class Bloxley::PatchController < Bloxley::ControllerBase

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  EVENT_STRINGS = { enter: "enter", exit: "exit" }

  animator    Bloxley::PatchAnimator

  illustrator Bloxley::PatchIllustrator

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(game)
    super(game, "Patch")
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################

  def can_enter(action, source, target)
    action.succeed
  end

  def can_exit(action, source, target)
    action.succeed
  end

  def create_patch(char)
    patch_key = library.key_for_tile(char)

    Bloxley::Patch.new(self, patch_key, tile: char).tap do |patch|
      setup(patch)
    end
  end

  def library
    @library ||= Bloxley::TileLibrary.new
  end

  def tile(key, chars, frame = nil)
    library.add_tile key, chars, frame
  end

  def tiles(hash)
    hash.each do |key, value|
      tile key, value
    end
  end
      

end
