class Bloxley::TileLibrary < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :tiles

  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(tiles)
    @tiles = {}
    @default_tile = tiles.first

    tiles.each { |tile| add_tile tile }
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def add_tile(tile)
    @default_tile ||= tile
    tiles[ tile.key ] = tile
  end

  def default_key
    @default_tile ? @default_tile.key : nil
  end

  def key_for_tile(tile_string)
    return default_key unless tile_string

    tile = tiles.detect { |t| t.acts_as_tile?(tile_string) }

    tile ? tile.key : default_key
  end

  def frame_for_key(key)
    tile = tile_for_key(key)

    tile ? tile.frame : nil
  end

  def tile_for_key(key)
    tiles[ key ]
  end

  def keys
    tiles.keys
  end

  def count
    tiles.length
  end

end
