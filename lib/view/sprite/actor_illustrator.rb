class Bloxley::ActorIllustrator < Bloxley::Base

      def initialize
        @sprites = {}
      end

      #   // Returns the class name for the kind of movie clip to use to display the given actor.  If you return `Foo`, then bloxley will call `new game.Foo()` for the sprite.  By default it just returns the actor's key.
      #   //
      #   // _Should you override this?_ Probably not.  Having the graphic name and the key being the same keeps things consistent.
      #   //
      #   // _Should you call this?_ No.
      # public function graphicsName(actor:BXActor):String {
      #     return key();
      # }

      def graphics_name(actor)
        actor.key
      end

      #   // Returns a `[length, width]` pair corresponding to how big the actor `actor` should appear on-screen (1 patch = 1.0).  By default returns `[1.0, 1.0]`.
      #   //
      #   // _Should you override this?_ Only if the actor's sprite shouldn't take up exactly one patch.
      #   //
      #   // _Should you call this?_ No.
      # public function dimensions(actor:BXActor):Array {
      #   return [ 1.0, 1.0 ];
      # }

      def dimensions(actor)
        [ 1.0, 1.0 ]
      end

      #   // Returns the name of the frame to display for the given actor's sprite.  By default, it returns `null`, which makes bloxley display the movie clip's first frame.
      #   //
      #   // _Should you override this?_ Yes, if you have multiple frames for the actor, and need to display a particular one.
      #   //
      #   // _Should you call this?_ No.
      # public function frameName(actor:BXActor):String {
      #     return null;
      # }

      def frame_name(actor)
      end

      #   // Is the registration point for the sprite's movie clip in the center (as opposed to the top left corner).  By default returns `false`.
      #   //
      #   // _Should you override this?_ Only if the actor's sprite is centered around the registration point.  This is useful for when the sprite's dimensions aren't `[1.0, 1.0]`.
      #   //
      #   // _Should you call this?_ No.
      # public function registrationAtCenter(actor:BXActor):Boolean {
      #     return false;
      # }

      def registration_at_center(actor)
        false
      end

      #   // Generates a sprite for the actor `actor`.  It takes in an empty `BXCompositeSprite`, and inserts the sprite's movie clip.  This is called when the sprite is first generated.  This returns the movie clip as well, to allow method chaining.
      #   //
      #   // _Should you override this?_ No, most methods depend on it working the way it does.
      #   //
      #   // _Should you call this?_ No.
      #   public function renderActorSprite(actor:BXActor, sprite:BXCompositeSprite):BXCompositeSprite {
      #       // Store it as the sprite for the provided actor...
      #       sprites[ actor ] = sprite;

      #       displaySprite(actor, sprite);
      #       resizeSprite(actor, sprite);
      #       initializeSprite(actor, sprite);

      #       return sprite;
      #   }

      def render_actor_sprite(actor, sprite)
        @sprites[actor] = sprite

        display_sprite(actor, sprite)
        resize_sprite(actor, sprite)
        initialize_sprite(actor, sprite)

        sprite
      end

      #   // Sets the sprite `sprite` to the correct clip and frame, by calling `graphicsName()` and `frameName()`.
      #   //
      #   // _Should you override this?_ No, most methods depend on it working the way it does.
      #   //
      #   // _Should you call this?_ No.
      #   function displaySprite(actor:BXActor, sprite:BXCompositeSprite) {
      #       if (graphicsName(actor)) {
      #           sprite.addSpriteLayer(graphicsName(actor), { centered: registrationAtCenter(actor) } );

      #           if (frameName(actor)) sprite.frame( frameName(actor) );
      #       }
      #   }

      def display_sprite(actor, sprite)
        if g_name = graphics_name(actor)
          sprite.add_sprite_layer(g_name, centered: registration_at_center(actor))

          if f_name = frame_name(actor)
            sprite.frame( f_name )
          end
        end
      end

      #   // Resize the sprite `sprite` to the correct screen size, by calling `dimensions()`.
      #   //
      #   // _Should you override this?_ No, most methods depend on it working the way it does.
      #   //
      #   // _Should you call this?_
      #   function resizeSprite(actor:BXActor, sprite:BXSprite) {
      #   sprite.resize(dimensions(actor));
      #   }

      def resize_sprite(actor, sprite)
        sprite.resize dimensions(actor)
      end

      #   // A hook to allow any custom sprite initialization to be performed.  By default it does nothing.
      #   //
      #   // _Should you override this?_ Yes, if you want to modify the sprite at all when it is created.
      #   //
      #   // _Should you call this?_ No.
      # public function initializeSprite(actor:BXActor, sprite:BXSprite) {
      #   // OVERRIDE ME!
      # }

      def initialize_sprite(actor, sprite)

      end


end
