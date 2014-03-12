class Bloxley::PhaseTransition < Bloxley::Base

  Null = new("No Phase", :terminal, {})

  def initialize(next_phase_name, transition, options)
    @next_phase_name = next_phase_name
    @transition      = transition
    @options         = options
  end

  def to?(phase)
    @next_phase_name == phase.name
  end

end
