package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;
import scenes.*;

class Crown extends Entity
{
    var player:Player;
    var nymph:Nymph;
    var crownSfx:Sfx;
    var sprite:Image;

    public function new(x:Int, y:Int)
    {
      super(x, y);
      sprite = new Image("graphics/crown.png");
      sprite.smooth = false;
      graphic = sprite;
      crownSfx = new Sfx("audio/pickup_crown.mp3");
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
        GameScene.caveMusic.stop();
        HXP.engine.scene = new scenes.Ending("player");
      }
      else if(collideWith(nymph, x, y) != null) {
        crownSfx.play();
        GameScene.caveMusic.stop();
        HXP.engine.scene = new scenes.Ending("nymph");
      }
      else if(collide('enemy', x, y) != null) {  // if its not a nymph its a stalker
        var enemy = collide('enemy', x, y);
        if(enemy.name == 'stalker') {
            crownSfx.play();
            GameScene.caveMusic.stop();
            HXP.engine.scene = new scenes.Ending("stalker");
        }
      }

      super.update();
    }
}
