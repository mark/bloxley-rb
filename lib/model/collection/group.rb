require_relative 'set'

class Bloxley::Group < Bloxley::Set

  def that_are_at(patch)
    that_are { |actor| actor.where_am_i.contains?(patch) }
  end

  def that_are_not_at(patch)
    that_are_not { |actor| actor.where_am_i.contains?(patch) }
  end

  def that_are_in(region)
    that_are { |actor| actor.where_am_i.overlaps?(region) }
  end

  def that_are_not_in(region)
    that_are_not { |actor| actor.where_am_i.overlaps?(region) }
  end

  def that_are_within(region)
    that_are { |actor| actor.where_am_i.contained_in?(region) }
  end

  def that_are_not_within(region)
    that_are_not { |actor| actor.where_am_i.contained_in?(region) }
  end

  # /******************
  # *                 *
  # * That Are Active *
  # *                 *
  # ******************/

  def that_are_active
    that_are { |actor| actor.active? }
  end

  def that_are_not_active
    that_are_not { |actor| actor.active? }
  end

  # /*********************
  # *                    *
  # * That Can Be Player *
  # *                    *
  # *********************/

  def that_can_be_player
    that_are { |actor| actor.active? && actor.can_be_player? }
  end

  #   /********************
  #   *                   *
  #   * Game Flow Helpers *
  #   *                   *
  #   ********************/

  def are_all_good?
    are_there_any? && must_be(:good?)
  end

  def are_any_good?
    that_are(:good?).are_there_any?
  end

  def are_all_disabled?
    must_be(:active?)
  end

  def are_any_disabled?
    that_are_not(:active?).must_any?
  end

end
