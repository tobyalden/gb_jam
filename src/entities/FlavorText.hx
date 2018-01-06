package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import flash.geom.Point;

class FlavorText extends Entity
{
    var player:Player;
    var hasEmoted:Bool;

    var emoteText:String;

    public function new(x:Int, y:Int, emoteText:String)
    {
      super(x, y);
      this.emoteText = emoteText;
      hasEmoted = false;
    }

    override public function update()
    {
      if(player == null) {
          player = cast(HXP.scene.getInstance("player"), Player);
      }
      if(player.getScreenCoordinates().equals(getScreenCoordinates())) {
        if(!hasEmoted) {
          HUD.hud.echo(emoteText);
          hasEmoted = true;
        }
      }
      else {
        hasEmoted = false;
      }
      super.update();
    }

    public function getScreenCoordinates() {
      return new Point(
        Math.floor(centerX / 160),
        Math.floor(centerY / 144)
      );
    }

}
