package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Angel extends ActiveEntity
{

  public static inline var SPEED = 0.02;
  public static inline var DRIFT_RATE = 80;
  public static inline var MAX_VELOCITY = 1;
  public static inline var BLESS_INTERVAL = 60;

  private var facing:String;
  private var player:Player;

  private var blessTimer:GameTimer;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    sprite = new Spritemap("graphics/angel.png", 16, 16);
    sprite.add("down", [0, 1], 3);
    sprite.add("left", [2, 3], 3);
    sprite.add("right", [4, 5], 3);
    sprite.add("up", [6, 7], 3);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -1);

    blessTimer = new GameTimer(BLESS_INTERVAL);

    type = "enemy";
    layer = -9999;

		finishInitializing();
	}

  public override function update()
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
    if(!blessTimer.isActive()) {
      bless();
    }
    super.update();
  }

  override private function takeDamage(spell:Entity)
  {
    HUD.hud.echo("ANGEL'S BODY ABSORBS YOUR SPELL");
  }

  /*override public function emote()
  {
      var message:String = sayings.shift();
      HUD.hud.echo(message);
      sayings.push(message);
  }*/

  private function bless()
  {
    HXP.scene.add(new Spit(Math.round(centerX), Math.round(centerY), facing));
    blessTimer.reset();
  }
}
