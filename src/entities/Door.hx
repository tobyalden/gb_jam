package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class Door extends ActiveEntity
{

    public static inline var STARTING_HEALTH = 15;

    private var facing:String;
    private var player:Player;

    public function new(x:Int, y:Int)
    {
      super(x, y);
      sprite = new Spritemap("graphics/door.png", 16, 16);
      sprite.add("down", [0, 1], 3);
      sprite.add("left", [2, 3], 3);
      sprite.add("right", [4, 5], 3);
      sprite.add("up", [6, 7], 3);
      sprite.play("down");
      facing = "down";
      setHitbox(11, 15, -3, -1);
      health = STARTING_HEALTH;
      setHitbox(16, 16);
      type = "door";
      finishInitializing();
    }

    override public function update()
    {
      if(player == null) {
          player = cast(HXP.scene.getInstance("player"), Player);
      }

      if(Math.abs(centerX - player.centerX) > Math.abs(centerY - player.centerY))
      {
        if(centerX > player.centerX) {
          facing = "left";
        }
        else {
          facing = "right";
        }
      }
      else {
        if(centerY > player.centerY) {
          facing = "up";
        }
        else {
          facing = "down";
        }
      }
      sprite.play(facing);
      checkDamage();
      super.update();
    }

    override private function takeDamage(spell:Entity)
    {
      health -= 1;
      if(health == Math.round(STARTING_HEALTH/2)) {
        HUD.hud.echo("DOOR WINCES IN PAIN");
      }
      invincibleTimer.reset();
      if(health <= 0) {
        HXP.scene.add(new Explosion(Math.round(x), Math.round(y)));
        HXP.scene.remove(this);
      }
    }


    override public function emote()
    {
      HUD.hud.echo("THE DOOR LOOKS ON PASSIVELY");
    }
}
