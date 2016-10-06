package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Heart extends Entity
{
    public function new(x:Int, y:Int)
    {
      super(x, y);
      graphic = new Image("graphics/heart.png");
      setHitbox(9, 9);
    }

    override public function update()
    {
      var _player:Entity = collide("player", x, y);
      if(_player != null)
      {
        var player = cast(_player, Player);
        player.health += 1;
        HXP.scene.remove(this);
      }
      super.update();
    }
}
