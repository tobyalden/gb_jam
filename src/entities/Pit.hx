package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Pit extends Entity
{
    private var sprite:Image;

  	public function new(x:Int, y:Int)
  	{
      super(x, y);
      sprite = new Image("graphics/pit.png");
      sprite.smooth = false;
      graphic = sprite;
      setHitbox(10, 4, -3, -3);
      type = "pit";
    }
}
