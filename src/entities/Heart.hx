package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Heart extends Entity
{
    private var heartSfx:Sfx;

    public function new(x:Int, y:Int)
    {
      super(x + 3, y + 3);
      graphic = new Image("graphics/heart.png");
      setHitbox(9, 9);
      heartSfx = new Sfx("audio/heart.wav");
    }

    override public function update()
    {
      var _player:Entity = collide("player", x, y);
      if(_player != null)
      {
        var player = cast(_player, Player);
        player.health += 1;
        heartSfx.play();
        HUD.hud.echo("YOU FEEL A LITTLE BETTER");
        HXP.scene.remove(this);
      }
      super.update();
    }
}
