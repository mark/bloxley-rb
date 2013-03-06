class Bloxley::ControllerBase < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################

  attr_reader :game

  EVENT_STRINGS = {}

  ##############
  #            #
  # Exceptions #
  #            #
  ##############
  
  class NoAnimatorError    < StandardError; end

  class NoIllustratorError < StandardError; end

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(game, key)
    @game         = game
    @key          = key
    @sprites      = {}
  end

  #################
  #               #
  # Class Methods #
  #               #
  #################

  def self.animator(animator_class = nil)
    @animator_class ||= animator_class
  end

  def self.illustrator(illustrator_class = nil)
    @illustrator_class ||= illustrator_class
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def animator_for(object)
    if klass = self.class.animator
      @animator ||= klass.new
    else
      raise NoAnimatorError
    end
  end

  def board
    game.board
  end

  def event_methods(event_str, source_key, target_key)
    %W(
      can_#{ source_key }_#{ event_str  }_#{ target_key }
      can_#{ event_str  }_#{ target_key }
      can_#{ source_key }_#{ event_str  }
      can_#{ event_str  }
    )
  end

  def illustrator_for(object)
    if klass = self.class.illustrator
      @illustrator ||= klass.new
    else
      raise NoIllustratorError
    end
  end

  def key(options = nil)
    @key
  end

  def resolve_event(action, event_key, source, target)
    event_str    = self.class::EVENT_STRINGS[ event_key ]
    method_names = event_methods(event_str, source.key, target.key)

    call_cascade method_names, action, source, target
  end

  def setup(object)
    # Override me!
  end

  def sprite_for(object)
    @sprites[ object ]
  end

end
