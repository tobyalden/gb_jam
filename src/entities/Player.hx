package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Player extends ActiveEntity
{

  public static inline var SPEED = 1;
  public static inline var KNOCKBACK_SPEED = 2;
  public static inline var ROLL_MULTIPLIER = 2;
  public static inline var ROLL_DURATION = 20;
  public static inline var ROLL_COOLDOWN = 12;
  public static inline var FALL_TIME = 120;

  public static inline var STUN_TIME = 17;
  public static inline var INVINCIBLE_TIME = 60;
  public static inline var STARTING_HEALTH = 3;
  public static inline var DEATH_TIME = 25000;

  private var rollTimer:GameTimer;
  private var rollCooldownTimer:GameTimer;
  private var fallTimer:GameTimer;
  private var facing:String;
  private var lastEntrance:Point;

  public var health:Int;
  private var stunTimer:GameTimer;
  private var invincibleTimer:GameTimer;
  private var deathTimer:GameTimer;

  private var prevCamera:Point;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    lastEntrance = new Point(x, y);
    prevCamera = new Point(0, 0);
    sprite = new Spritemap("graphics/player.png", 16, 25);
    sprite.add("down", [0, 1], 6);
    sprite.add("right", [2, 3], 6);
    sprite.add("left", [4, 5], 6);
    sprite.add("up", [6, 7], 6);
    sprite.add("roll_vertical", [8, 9, 10, 11], 6);
    sprite.add("roll_horizontal", [12, 13, 14, 15], 6);
    sprite.add("fall", [16, 17, 18, 19], 3, false);
    sprite.add("death", [20], false);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -11);

    rollTimer = new GameTimer(ROLL_DURATION);
    rollCooldownTimer = new GameTimer(ROLL_COOLDOWN);
    fallTimer = new GameTimer(FALL_TIME);
    stunTimer = new GameTimer(STUN_TIME);
    invincibleTimer = new GameTimer(INVINCIBLE_TIME);
    deathTimer = new GameTimer(DEATH_TIME);
    health = STARTING_HEALTH;
    name = "player";
    type = "player";
    layer = -9999;

		finishInitializing();
	}

  public function isDead()
  {
    return deathTimer.isActive();
  }

  public override function update()
  {

    if(fallTimer.wasActive() && !isDead()) {
      restartAtRoomEntrance();
    }

    var inControl:Bool = !rollTimer.isActive() && !fallTimer.isActive() && !stunTimer.isActive() && !deathTimer.isActive();

    if(inControl)
    {
      if(rollTimer.wasActive()) {
          rollCooldownTimer.reset();
      }
      if(Input.check(Key.LEFT)) {
        velocity.x = -SPEED;
        facing = "left";
      }
      else if(Input.check(Key.RIGHT)) {
        velocity.x = SPEED;
        facing = "right";
      }
      else {
        velocity.x = 0;
      }
      if(Input.check(Key.UP)) {
        velocity.y = -SPEED;
        facing = "up";
      }
      else if(Input.check(Key.DOWN)) {
        velocity.y = SPEED;
        facing = "down";
      }
      else {
        velocity.y = 0;
      }

      if(Input.check(Key.X)) {
        if(!rollCooldownTimer.isActive()) {
          rollTimer.reset();
          var singleDirectionMultipler:Float = 1;
          if(velocity.x == 0 || velocity.y == 0) {
            singleDirectionMultipler = 1.37;
          }
          velocity.x *= ROLL_MULTIPLIER * singleDirectionMultipler;
          velocity.y *= ROLL_MULTIPLIER * singleDirectionMultipler;
        }
      }
    }

    if(!rollTimer.isActive() && !fallTimer.isActive() && !stunTimer.isActive()) {
      var pit:Entity = collide("pit", x, y);
      if(pit != null) {
        velocity.x = 0;
        velocity.y = 0;
        x = pit.x;
        y = pit.y - 10;
        fallTimer.reset();
      }
    }


    moveBy(velocity.x, velocity.y, "walls");

    if(!deathTimer.isActive() && !fallTimer.isActive()) {
      if(invincibleTimer.isActive()) {
        graphic.visible = invincibleTimer.count % 2 == 0;
      }
      else {
        graphic.visible = true;
        var enemy:Entity = collide("enemy", x, y);
        if(enemy != null) {
          takeDamage(enemy);
        }
      }
    }
    else {
      velocity.x /= 1.1;
      velocity.y /= 1.1;
    }

    if(Input.check(Key.ESCAPE)) {
      System.exit(0);
    }

    animate();


    HXP.scene.camera.x = Math.floor(centerX / HXP.screen.width) * HXP.screen.width;
    HXP.scene.camera.y = Math.floor(centerY / HXP.screen.height) * HXP.screen.height;

    if(!prevCamera.equals(new Point(HXP.scene.camera.x, HXP.scene.camera.y))) {
      lastEntrance.x = x;
      lastEntrance.y = y;
      if(HXP.scene.camera.x > prevCamera.x) {
        lastEntrance.x += 8;
      }
      else if(HXP.scene.camera.x < prevCamera.x) {
        lastEntrance.x -= 8;
      }
      else if(HXP.scene.camera.y > prevCamera.y) {
        lastEntrance.y += 8;
      }
      else {
        lastEntrance.y -= 8;
      }
    }

    prevCamera = new Point(HXP.scene.camera.x , HXP.scene.camera.y);

    super.update();
  }

  private function takeDamage(enemy:Entity)
  {
    health -= 1;
    stunTimer.reset();
    invincibleTimer.reset();
    if(health == 0) {
      deathTimer.reset();
    }
    if(Math.abs(centerX - enemy.centerX) > Math.abs(centerY - enemy.centerY))
    {
      if(centerX > enemy.centerX) {
        facing = "left";
        velocity.x = KNOCKBACK_SPEED;
      }
      else {
        facing = "right";
        velocity.x = -KNOCKBACK_SPEED;
      }
    }
    else {
      if(centerY > enemy.centerY) {
        facing = "up";
        velocity.y = KNOCKBACK_SPEED;
      }
      else {
        facing = "down";
        velocity.y = -KNOCKBACK_SPEED;
      }
    }
  }

  private function animate()
  {
    if(fallTimer.isActive()) {
      sprite.play("fall");
    }
    else if(deathTimer.isActive()) {
      sprite.play("death");
    }
    else if(rollTimer.isActive()) {
      if(velocity.y != 0) {
        sprite.play("roll_vertical");
      }
      else {
        sprite.play("roll_horizontal");
      }
    }
    else {
      if(velocity.x != 0 || velocity.y != 0) {
        sprite.play(facing);
      }
      else {
        if(rollTimer.wasActive()) {
          sprite.play(facing);
        }
        sprite.stop();
      }
    }
  }

  private function restartAtRoomEntrance()
  {
    x = lastEntrance.x;
    y = lastEntrance.y;
    sprite.play(facing);
    invincibleTimer.reset();
  }

  public function isShadowVisible()
  {
    return rollTimer.isActive();
  }

}
