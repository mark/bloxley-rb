class Bloxley::ActorFactory < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :controller, :board_string, :attributes

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(controller, options = {})
    @controller   = controller
    @board_string = options[:board_string]
    @attributes   = options[:attributes]
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def can_load_from_board?(tile)
    board_string && board_string[tile]
  end

  def create_actor(options)
    Bloxley::Actor.new(controller, controller.key(options), options)
  end

  def create_actor_from_attributes(options) 
    if attributes
      attributes = parse_actor_attributes(options)
      create_actor attributes
    else
      nil
    end
  end

  def create_actor_from_board(tile)
    if can_load_from_board?(tile)
      create_actor tile: tile
    else
      nil
    end
  end
  
  def parse_actor_attribute(key, value, type)
    if key == 'x' || key == 'y' || type == 'Number'
      value.to_i
    elsif type == 'Boolean'
      value == "Yes"
    elsif type == 'Color'
      Bloxley::Color[ value ]
    elsif type == 'String'
      value
    elsif type == 'Direction'
      Bloxley::Direction[ value ]
    end
  end

  def parse_actor_attributes(object_attributes)
    Hash.new.tap do |attrs|
      object_attributes.each do |key, value|
        type       = attributes[key]
        attr       = parse_actor_attribute(key, value, type)
        attrs[key] = attr unless attr.nil?
      end
    end
  end

end
