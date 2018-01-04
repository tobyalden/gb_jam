package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Shadow extends Entity
{
    private var sprite:Spritemap;
    private var player:Player;

  	public function new(x:Int, y:Int)
  	{
      super(x, y);
      sprite = new Spritemap("graphics/shadow.png", 16, 25);
      sprite.add("idle", [0, 1, 2, 3, 4, 5, 6, 7], 6);
      sprite.play("idle");
      graphic = sprite;
      setHitbox(11, 15, -3, -11);
    }

    override public function update()
    {
      if(player == null) {
        var _player:Entity = HXP.scene.getInstance("player");
        if(_player != null) {
          player = cast(_player, Player);
        }
      }
      else {
        x = player.x;
        y = player.y;
        visible = player.isShadowVisible();
      }
      super.update();
    }
}
