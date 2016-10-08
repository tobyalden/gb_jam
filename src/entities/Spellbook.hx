package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Spellbook extends Entity
{
    public function new(x:Int, y:Int)
    {
      super(x, y);
      graphic = new Image("graphics/spellbook.png");
      setHitbox(16, 16);
    }

    override public function update()
    {
      var _player:Entity = collide("player", x, y);
      if(_player != null)
      {
        var player = cast(_player, Player);
        player.hasSpellbook = true;
        HUD.hud.echo("YOU FEEL POWER WASH OVER YOU");
        HUD.hud.echo("PRESS X TO CAST A SPELL");
        HXP.scene.remove(this);
      }
      super.update();
    }
}
