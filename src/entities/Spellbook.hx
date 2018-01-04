package entities;

import com.haxepunk.*;
import com.haxepunk.utils.*;
import com.haxepunk.graphics.*;

class Spellbook extends Entity
{

    public var spellbookSfx:Sfx;
    private var deleteSelf:Bool;

    public function new(x:Int, y:Int)
    {
      Data.load('familySave');
      deleteSelf = Data.read('hasSpellbook', false);
      super(x, y);
      graphic = new Image("graphics/spellbook.png");
      spellbookSfx = new Sfx("audio/spellbook.wav");
      setHitbox(16, 16);
    }

    override public function update()
    {
      if(deleteSelf) {
        HXP.scene.remove(this);
      }
      var _player:Entity = collide("player", x, y);
      if(_player != null)
      {
        var player = cast(_player, Player);
        player.hasSpellbook = true;
        HUD.hud.echo("YOU FEEL POWER WASH OVER YOU");
        HUD.hud.echo("PRESS X TO CAST A SPELL");
        spellbookSfx.play();
        HXP.scene.remove(this);
      }
      super.update();
    }
}
