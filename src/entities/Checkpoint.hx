package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import com.haxepunk.utils.*;

class Checkpoint extends ActiveEntity
{
    private var player:Player;
    private var nymph:Nymph;
    private var hasSaved:Bool;

    public function new(x:Int, y:Int)
    {
      super(x, y);
      sprite = new Spritemap("graphics/checkpoint.png", 16, 32);
      sprite.add("idle", [
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1,
        1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0
      ], 6);
      sprite.play("idle");
      hasSaved = false;
      setHitbox(16, 8, 0, -24);
      type = "walls";
      finishInitializing();
      layer = -99999;
    }

    override public function update()
    {
      if(player == null) {
          player = cast(HXP.scene.getInstance("player"), Player);
      }
      if(nymph == null) {
          nymph = cast(HXP.scene.getInstance("nymph"), Nymph);
      }
      if(player.getScreenCoordinates().equals(getScreenCoordinates())) {
        if(!hasSaved) {
          save(player);
        }
      }
      else {
        hasSaved = false;
      }
      super.update();
    }

    private function save(player:Player) {
      Data.write("saveX", x);
      Data.write("saveY", bottom);
      Data.write("hasSpellbook", player.hasSpellbook);
      if(nymph.getScreenCoordinates().equals(getScreenCoordinates())) {
        HUD.hud.echo("YOU AND NYMPH ARE REMEMBERED");
        Data.write("friendX", x);
        trace("friendX is " + x);
        Data.write("friendY", top-16);
      }
      else {
        HUD.hud.echo("YOU HAVE BEEN REMEMBERED");
      }
      Data.save("familySave");
      hasSaved = true;
    }
}
