class Bloxley::PatchIllustrator < Bloxley::Base

  def graphics_name(patch)
    "Patch"
  end

  def frame_name(patch)
    library.frame_for_key patch.key
  end

  def registration_at_center(patch)
    false
  end

  #     public function renderPatchSprite(patch:BXPatch, sprite:BXCompositeSprite):BXCompositeSprite {
  #         sprites[ patch ] = sprite;
          
  #         displaySprite(patch, sprite);
  #         resizeSprite(patch, sprite);
  #         initializeSprite(patch, sprite);
          
  #         return sprite;
  #     }

  def generate_sprite(patch, geometry)
    # var controller = patch.patchController();
    # var sprite = layerNamed("patchLayer").addEmptyLayer({ centered: controller.registrationAtCenter(patch) });
    
    # sprite.setGeometry( geometry() );
    # sprite.goto( patch );
    
    # controller.renderPatchSprite(patch, sprite);
  end

  def render_sprite(patch, sprite)

  end

  
  #     // Set it to the correct clip and frame
  #     function displaySprite(patch:BXPatch, sprite:BXCompositeSprite) {
  #         var layer = sprite.addSpriteLayer( graphicsName(patch) );
  #         var frame = frameName(patch);
          
  #         if (frame)
  #             sprite.frame( frameName(patch) );
  #     }

  def display_sprite(patch, sprite)

  end

  #     function resizeSprite(patch:BXPatch, sprite:BXSprite) {
  #         // Resize the sprite to the current screen size...
  #         if (sprite is BXCompositeSprite) {
  #             (sprite as BXCompositeSprite).layer(0).resize([ 1.0, 1.0 ]);
  #             // sprite.resize([ 1.0, 1.0 ]);
  #         } else {
  #             sprite.resize([ 1.0, 1.0 ]);
  #         }
  #     }
  
  def resize_sprite(patch, sprite)
  end

  #   public function initializeSprite(patch:BXPatch, sprite:BXSprite) { 
  #     // OVERRIDE ME!
  #   }

  def setup_sprite(patch, sprite)

  end

end
