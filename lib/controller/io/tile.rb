class Bloxley::Tile < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :key, :frame

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(key, chars, frame)
    @key   = key
    @chars = chars
    @frame = frame || key
  end

  def acts_as_tile?(tile_string)
    !! @chars[tile_string]
  end

  def to_xml
    @chars[0]
  end

end
