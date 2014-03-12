class Bloxley::GameExecution < Bloxley::Base

  ################
  #              #
  # Declarations #
  #              #
  ################
  
  ###############
  #             #
  # Constructor #
  #             #
  ###############
  
  def initialize(game_loop)
    @game_loop  = game_loop
    @phase      = game_loop.initial_phase

    reset_run_count
  end

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################
  
  def first_run?
    @run_count == 0
  end

  def run
    @transition = @phase.run(self)

    reset_run_count unless @transition.to(@phase)

    @phase = @game_loop.phase_named @transition.next_phase_name
  end

  def finished?
    @transition.terminal?
  end

  protected

  def reset_run_count
    @run_count = 0
  end

end
