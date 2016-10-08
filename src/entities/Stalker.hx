package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Stalker extends ActiveEntity
{

  public static inline var SPEED = 0.65;
  public static inline var STARTING_HEALTH = 6;

  private var facing:String;
  private var player:Player;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    sprite = new Spritemap("graphics/stalker.png", 16, 16);
    sprite.add("down", [0, 1], 6);
    sprite.add("right", [2, 3], 6);
    sprite.add("left", [4, 5], 6);
    sprite.add("up", [6, 7], 6);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -1);

    health = STARTING_HEALTH;

    type = "enemy";
    layer = -9999;

		finishInitializing();
	}

  // the stalker walks towards you if you're not facing the opposite direction as him
  public override function update()
  {
    if(player == null) {
        player = cast(HXP.scene.getInstance("player"), Player);
    }

    if(player.isDead()) {
      sprite.stop();
      return;
    }

    if(centerX > player.centerX && !isAgainstLeftWall()) {
      velocity.x = -SPEED;
      velocity.y = 0;
      facing = "left";
      sprite.play(facing);
    }
    else if(centerX < player.centerX && !isAgainstRightWall()) {
      velocity.x = SPEED;
      velocity.y = 0;
      facing = "right";
      sprite.play(facing);
    }
    else if(centerY > player.centerY && !isAgainstTopWall()) {
      velocity.y = -SPEED;
      velocity.x = 0;
      facing = "up";
      sprite.play(facing);
    }
    else if(centerY < player.centerY && !isAgainstBottomWall()) {
      velocity.y = SPEED;
      velocity.x = 0;
      facing = "down";
      sprite.play(facing);
    }
    else {
      velocity.x = 0;
      velocity.y = 0;
      if(centerX > player.centerX) {
        sprite.play("left");
      }
      else if(centerX < player.centerX) {
        sprite.play("right");
      }
      else if(centerY > player.centerY) {
        sprite.play("up");
      }
      else if(centerY < player.centerY) {
        sprite.play("down");
      }
      sprite.stop();
    }

    checkDamage();

    moveBy(velocity.x, velocity.y, ["walls", "pit"]);

    super.update();
  }

  override public function emote()
  {
    if(velocity.x == 0 && velocity.y == 0) {
      HUD.hud.echo("STALKER STARES AT YOU");
    }
    else if(velocity.y == 0) {
      HUD.hud.echo("STALKER TRIES TO GET IN YOUR WAY");
    }
    else {
      HUD.hud.echo("STALKER ADVANCES WORDLESSLY");
    }
  }

  override public function moveCollideX(e:Entity)
  {
    sprite.stop();
    return true;
  }

  override public function moveCollideY(e:Entity)
  {
    sprite.stop();
    return true;
  }

}
