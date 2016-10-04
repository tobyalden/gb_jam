package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Pit extends Entity
{
  	public function new(x:Int, y:Int)
  	{
      super(x, y);
      graphic = new Image("graphics/pit.png");
      setHitbox(10, 4, -3, -3);
      type = "pit";
    }
}
