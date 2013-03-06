class Bloxley::ActorAnimator < Bloxley::Base

      #   // Returns the default movement speed for animating this sprite when it moves around.  Used by the default implementation of `animateMove()`.  Measured in patches per second.  By default, it returns `8.0`.
      #   // 
      #   // _Should you override this?_ If you want a different default speed for your animations.
      #   // 
      #   // _Should you call this?_ You can, if you override `animateMove()` but still want to use this method.  Not really necessary, though.
      #   public function defaultSpeed():Number {
      #       return 8.0;
      #   }
        
      #   // Returns the animation when the actor `actor` is moved by the action `action`.  By default, it just returns a `BXSprite#goto` animation.
      #   // 
      #   // _Should you override this?_ If you want a more interesting animation than the sprite sliding around.
      #   // 
      #   // _Should you call this?_ No, this is called by a choreographer.
      #   public function animateMove(actor:BXActor, action:BXMoveAction) {
      #     return spriteForActor(actor).goto(action.newPosition, { speed: defaultSpeed() });
      # }

      #   public function animateUndoMove(actor:BXActor, action:BXMoveAction) {
      #     return spriteForActor(actor).goto(action.oldPosition, { instant: true });
      #   }

      #   // Returns the animation when the actor `actor` is selected by the action `action`.  By default, it does nothing.
      #   // 
      #   // _Should you override this?_ If you want to animate when an actor is selected.  Which you probably do.
      #   // 
      #   // _Should you call this?_ No, this is called by a choreographer.
      #   public function animateSelect(actor:BXActor, oldActor:BXActor, action:BXSelectAction) {
      #       // OVERRIDE ME!
      #   }

      #   public function animateUndoSelect(actor:BXActor, oldActor:BXActor, action:BXSelectAction) {
      #       // OVERRIDE ME!
      #   }
        
      #   public function animateDisable(actor:BXActor, action:BXDisableAction) {
      #       return spriteForActor(actor).hide({ seconds: 0.5 });
      #   }
        
      #   public function animateUndoDisable(actor:BXActor, action:BXDisableAction) {
      #       return spriteForActor(actor).show();
      #   }

end
