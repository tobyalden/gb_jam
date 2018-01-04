package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Explosion extends ActiveEntity
{
    public function new(x:Int, y:Int)
    {
      super(x, y);
      sprite = new Spritemap("graphics/explosion.png", 16, 16);
      sprite.add("explode", [1, 2], 4, false);
      sprite.play("explode");
      finishInitializing();
    }

    override public function update()
    {
      if(sprite.complete) {
        HXP.scene.remove(this);
      }
      super.update();
    }
}
