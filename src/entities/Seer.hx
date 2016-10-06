package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Seer extends ActiveEntity
{

  public static inline var SPEED = 0.02;
  public static inline var DRIFT_RATE = 80;
  public static inline var MAX_VELOCITY = 1;

  private var facing:String;
  private var player:Player;

  private var prevX:Float;
  private var prevY:Float;

  private var drift:Float;
  private var prevDrift:Float;
  private var driftTimer:GameTimer;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    prevX = x;
    prevY = y;
    drift = 0;
    prevDrift = 0;
    sprite = new Spritemap("graphics/seer.png", 16, 16);
    sprite.add("down", [0]);
    sprite.add("right", [1]);
    sprite.add("left", [2]);
    sprite.add("up", [3]);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -1);

    type = "enemy";
    layer = -9999;

    driftTimer = new GameTimer(Math.round(2 * Math.PI) * DRIFT_RATE);
    driftTimer.autoReset = true;
    driftTimer.reset();

		finishInitializing();
	}

  public override function update()
  {

    if(player == null) {
        player = cast(HXP.scene.getInstance("player"), Player);
    }

    if(player.isDead()) {
      return;
    }

    if(!getScreenCoordinates().equals(player.getScreenCoordinates()))
    {
      x = startPosition.x;
      y = startPosition.y;
      velocity.x = 0;
      velocity.y = 0;
      return;
    }

    if(centerY < player.centerY) {
      velocity.y += SPEED;
    }
    else if(centerY > player.centerY) {
      velocity.y -= SPEED;
    }
    else {
      velocity.y = 0;
    }

    if(centerX > player.centerX) {
      velocity.x -= SPEED;
    }
    else if(centerX < player.centerX) {
      velocity.x += SPEED;
    }
    else {
      velocity.x = 0;
    }

    if(velocity.x > MAX_VELOCITY) {
      velocity.x = MAX_VELOCITY;
    }
    else if(velocity.x < -MAX_VELOCITY) {
      velocity.x = -MAX_VELOCITY;
    }

    if(velocity.y > MAX_VELOCITY) {
      velocity.y = MAX_VELOCITY;
    }
    else if(velocity.y < -MAX_VELOCITY) {
      velocity.y = -MAX_VELOCITY;
    }

    drift = Math.sin(driftTimer.count / DRIFT_RATE);


    /*trace("prevDrift is " + prevDrift + ". drift is " + drift);*/

    var modX:Float = Math.abs(drift);
    var modY:Float = Math.abs(drift);

    moveBy(velocity.x * modX, velocity.y * modY, "walls");

    if(Input.check(Key.ESCAPE)) {
      System.exit(0);
    }

    animate();
    if(drift / prevDrift < 0) {
      spit();
    }

    prevDrift = drift;
    if(prevDrift == 0) {
      prevDrift = 0.000001;
    }


    super.update();
  }

  private function animate()
  {
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
  }

  private function spit()
  {
    HXP.scene.add(new Spit(Math.round(centerX), Math.round(centerY), facing));
  }

  override public function moveCollideX(e:Entity)
  {
      velocity.x = 0;
      return true;
  }

  override public function moveCollideY(e:Entity)
  {
      velocity.y = 0;
      return true;
  }

}
