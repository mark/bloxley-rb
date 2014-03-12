class Bloxley::Actor < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  attr_reader :actor_controller, :board, :anchor_point

  attr_accessor :key

  def initialize(controller, key, info = {})
    @actor_controller = controller
    @key              = key
    @info             = info || {}
    @active           = true

    actor_controller.setup_actor(self)
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

  def attach(board, patch = nil)
    @board = board
    place_at patch if patch
  end

  def sprite
    raise NotImplementedError, "I'm not sure I want this defined"
  end

  def place_at(patch)
    @anchor_point = patch
    region_changed
  end

  def where_am_i
    @region ||= actor_controller.region_for_actor_at_location(self, @anchor_point)
  end

  def am_i_at?(patch)
    where_am_i.contains?(patch)
  end

  def am_i_in?(region)
    where_am_i.overlaps?(region)
  end

  def am_i_within?(region)
    where_am_i.contained_in?(region)
  end

  def am_i_standing_on?(patch_key)
    where_am_i.are_all_of_type?(patch_key)
  end

  def enable
    unless active?
      @active = true
      region_changed
    end
  end

  def disable
    unless disabled?
      @active = false
      region.clear
    end
  end

  def active?
    @active
  end

  def disabled?
    ! active?
  end

  def can_be_player?
    ask(:actor_can_be_player?)
  end

  def step_on_event(action, actor)
    actor.actor_controller.resolve_event(action, :step_on, actor, self)

    actor_controller.resolve_event(action, :stepped_on, self, actor)
  end

  def step_off_event(action, actor)
    actor.actor_controller.resolve_event(action, :step_off, actor, self)

    actor_controller.resolve_event(action, :stepped_off, self, actor)
  end

  # public function startingLocation():BXPatch {
  #   return lastLocation;
  # }

  def is_a?(test_key)
    key == test_key
  end

  def ask(method_name, *args)
    actor_controller.send(method_name, self, *args)
  end

  def good
    ask(:actor_good?)
  end

  protected

    def region_changed
      @region = nil
    end

end
