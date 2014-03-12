class Bloxley::Phase < Bloxley::Base

  #       var name:String;
  #     var gameLoop:BXGameLoop;

  #     var options:Object;

  #     // Main Loop elements

  #     var _runCount:Number;
  #     var _lastCall;
  #     var _lastRun:Boolean;

  #     var _nextPhase:BXPhase;
  #     var _transition:String;
  #     var _transitionOptions;

  ################
  #              #
  # Declarations #
  #              #
  ################

  FLOWS = [ :after, :pass, :fail, :pass_early, :pass_late, :fail_early, :fail_late ]

  COMBINED_FLOWS = {
    after: [ :pass_early, :pass_late, :fail_early, :fail_late ],
    pass:  [ :pass_early, :pass_late                          ],
    fail:  [                          :fail_early, :fail_late ]
  }

  ###############
  #             #
  # Constructor #
  #             #
  ###############

  def initialize(name, game_loop, options = {})
    @name        = name
    @game_loop   = game_loop
    @options     = options
    @run_count   = 0
    @transitions = {}

    @last_transition = Bloxley::PhaseTransition::Null

  end

  ########
  #      #
  # Null #
  #      #
  ########

  Null = new("Null", nil, {})

  ####################
  #                  #
  # Instance Methods #
  #                  #
  ####################

  def controller
    @game_loop.controller
  end

  FLOWS.each do |flow|
    define_method(flow) do |next_phase, *args|
      record_transition(flow, next_phase, args)
    end
  end

  def run(execution)
    if execution.first_run?
      on_enter
    end

    # @controller.start_monitoring_events
    result           = on_run
    phase_transition = determine_next_transition(execution.first_run?, result)

    unless phase_transition.to?(self)
      on_exit
    end

    return phase_transition
  end

  protected

  def execute_on_controller(method_name)
    if controller && controller.respond_to?(method_name)
      controller.send(method_name)
    end
  end

  def record_transition(flows, next_phase, args)
    base_flows = COMBINED_FLOWS[flows] || [flows]
    record     = PhaseTransition.new(next_phase, args)

    base_flows.each do |flow|
      @transitions[flow] = record
    end
  end

  def on_enter
    if @options[:enter]
      execute_on_controller @options[:enter]
    end
  end

  def on_run
    @run_count += 1

    if @options[:call]
      @last_call = execute_on_controller @options[:call]
    end
  end

  def on_exit
    cleanup

    if @options[:exit]
      execute_on_controller @options[:exit]
    end
  end

  #     /********************
  #     *                   *
  #     * Main Loop Methods *
  #     *                   *
  #     ********************/

  #     public function firstRun():Boolean {
  #         return _runCount == 0;
  #     }

  def determine_next_transition(first_run, last_call)
    transition = if last_call
      if first_run
        @transitions[:pass_early]
      else
        @transitions[:pass_late]
      end
    else
      if first_run
        @transitions[:fail_early]
      else
        @transitions[:fail_late]
      end
    end

    transition || raise(GameLoop::NoTransitionError)
  end

  #     public function nextPhase():BXPhase {
  #         return _nextPhase;
  #     }

  #     public function transition():String {
  #         return _transition;
  #     }

  #     public function transitionOptions() {
  #         return _transitionOptions;
  #     }

  #     public function cleanup() {
  #         _runCount = 0;
  #     }

  #     public function phaseName():String {
  #         return name;
  #     }

end
