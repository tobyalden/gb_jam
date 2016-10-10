package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Crown extends Entity
{
    var player:Player;
    var nymph:Nymph;
    var crownSfx:Sfx;

    public function new(x:Int, y:Int)
    {
      super(x, y);
      graphic = new Image("graphics/crown.png");
      crownSfx = new Sfx("audio/pickup_crown.wav");
      setHitbox(16, 16);
    }

    override public function update()
    {
      if(player == null) {
        player = cast(HXP.scene.getInstance("player"), Player);
      }
      if(nymph == null) {
        nymph = cast(HXP.scene.getInstance("nymph"), Nymph);
      }
      if(collideWith(player, x, y) != null) {
        crownSfx.play();
        HXP.engine.scene = new scenes.Ending("player");
      }
      if(collideWith(nymph, x, y) != null) {
        crownSfx.play();
        HXP.engine.scene = new scenes.Ending("nymph");
      }
      super.update();
    }
}
