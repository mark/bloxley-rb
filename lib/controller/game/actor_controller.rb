require_relative 'controller_base'
require_relative '../../view/animation/actor_animator'
require_relative '../../view/sprite/actor_illustrator'

class Bloxley::ActorController < Bloxley::ControllerBase

  ################
  #              #
  # Declarations #
  #              #
  ################

  EVENT_STRINGS = { step_on: "step_on", stepped_on_by: "be_stepped_on_by", leave: "leave", left_by: "be_left_by" }

  animator    Bloxley::ActorAnimator

  illustrator Bloxley::ActorIllustrator

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(game, key)
    super(game, key)
  end

  #################
  #               #
  # Class Methods #
  #               #
  #################

  def self.attributes(attribute_hash = nil)
    @attributes ||= attribute_hash
  end

  def self.board_string(string = nil)
    @board_string ||= string
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def actor_can_be_player?(actor)
    false
  end

  def actor_good?(actor)
    false
  end

  def can_be_stepped_on_by(action, source, target)
    action.fail
  end

  def can_be_left_by(action, source, target)
    action.succeed
  end

  def can_leave(action, source, target)
    action.succeed
  end

  def can_step_on(action, source, target)
    action.succeed
  end

  def create_actor_from_board(tile)
    factory.create_actor_from_board(tile)
  end

  def create_actor_from_attributes(options) 
    factory.create_actor_from_attributes(options)
  end

  def factory
    @factory = Bloxley::ActorFactory.new board_string: self.class.board_string, attributes: self.class.attributes
  end

  def region_for_actor(actor)
    region_for_actor_at_location(actor, actor.anchor_point)
  end
        
  def region_for_actor_at_location(actor, location)
    Bloxley::Region.new location
  end

end
