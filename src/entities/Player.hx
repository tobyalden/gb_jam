package entities;

import flash.geom.Point;
import flash.filesystem.*;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;
import scenes.*;

class Player extends ActiveEntity
{

  public static inline var SPEED = 1;
  public static inline var KNOCKBACK_SPEED = 2;
  public static inline var ROLL_MULTIPLIER = 2;
  public static inline var ROLL_DURATION = 20;
  public static inline var ROLL_COOLDOWN = 12;

  public static inline var CAST_COOLDOWN= 15;
  public static inline var CAST_DURATION= 20;

  public static inline var FALL_TIME = 120;

  public static inline var STUN_TIME = 17;
  public static inline var INVINCIBLE_TIME = 60;
  public static inline var STARTING_HEALTH = 3;
  public static inline var DEATH_TIME = 25000;
  public static inline var GAME_OVER_SCREEN_DELAY = 250;

  private var rollTimer:GameTimer;
  private var rollCooldownTimer:GameTimer;
  private var fallTimer:GameTimer;
  private var facing:String;
  public var lastEntrance:Point;

  private var stunTimer:GameTimer;
  private var deathTimer:GameTimer;
  private var gameOverScreenTimer:GameTimer;

  private var castDurationTimer:GameTimer;
  private var castCooldownTimer:GameTimer;

  private var prevCamera:Point;

  public var hasSpellbook:Bool;

  private var isGameOver:Bool;

  public var castSfx:Sfx;
  public var deathSfx:Sfx;
  public var fallSfx:Sfx;
  public var flipSfx:Sfx;
  public var hitSfx:Sfx;

	public function new(x:Int, y:Int)
	{
    Data.load('familySave');
    var saveX:Int = Data.read('saveX', x);
    var saveY:Int = Data.read('saveY', y);
    var saveSpellbook:Bool = Data.read('hasSpellbook', false);
		super(saveX, saveY);
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
    sprite.add("death", [20]);
    sprite.add("cast_down", [21]);
    sprite.add("cast_right", [22]);
    sprite.add("cast_left", [23]);
    sprite.add("cast_up", [24]);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -11);

    rollTimer = new GameTimer(ROLL_DURATION);
    rollCooldownTimer = new GameTimer(ROLL_COOLDOWN);
    fallTimer = new GameTimer(FALL_TIME);
    stunTimer = new GameTimer(STUN_TIME);
    invincibleTimer = new GameTimer(INVINCIBLE_TIME);
    deathTimer = new GameTimer(DEATH_TIME);
    castCooldownTimer = new GameTimer(CAST_COOLDOWN);
    castDurationTimer = new GameTimer(CAST_DURATION);
    gameOverScreenTimer = new GameTimer(GAME_OVER_SCREEN_DELAY);
    stunTimer.reset();
    hasSpellbook = saveSpellbook;
    health = STARTING_HEALTH;
    name = "player";
    type = "player";
    layer = -9999;
    isGameOver = false;

    castSfx = new Sfx("audio/cast.mp3");
    deathSfx = new Sfx("audio/death.mp3");
    fallSfx = new Sfx("audio/fall.mp3");
    flipSfx = new Sfx("audio/flip.mp3");
    hitSfx = new Sfx("audio/hit.mp3");

		finishInitializing();
	}

  public function isDead()
  {
    return deathTimer.isActive();
  }

  public override function update()
  {

    if(gameOverScreenTimer.wasActive()) {
      HUD.hud.showGameOver();
      isGameOver = true;
    }

    if(isGameOver) {
      if(Input.check(Key.Z) || Input.check(Key.X)) {
        HXP.engine.scene = new GameScene();
      }
      return;
    }

    if(fallTimer.wasActive()) {
      restartAtRoomEntrance();
    }

    var inControl:Bool = !rollTimer.isActive() && !fallTimer.isActive() && !stunTimer.isActive() && !deathTimer.isActive() && !castDurationTimer.isActive();

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

      if(Input.check(Key.Z)) {
        if(!rollCooldownTimer.isActive()) {
          rollTimer.reset();
          flipSfx.play();
          var singleDirectionMultipler:Float = 1;
          if(velocity.x == 0 || velocity.y == 0) {
            singleDirectionMultipler = 1.37;
          }
          velocity.x *= ROLL_MULTIPLIER * singleDirectionMultipler;
          velocity.y *= ROLL_MULTIPLIER * singleDirectionMultipler;
        }
      }

      if(Input.check(Key.X)) {
        if(hasSpellbook && !castCooldownTimer.isActive()) {
          castSpell();
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
        if(!isDead()) {
          HUD.hud.echo("YOU PLUNGE INTO THE DARKNESS!");
          fallSfx.play();
        }
      }
    }


    moveBy(velocity.x, velocity.y, ["walls", "door"]);

    if(!deathTimer.isActive() && !fallTimer.isActive()) {
      if(invincibleTimer.isActive()) {
        graphic.visible = invincibleTimer.count % 2 == 0;
      }
      else {
        graphic.visible = true;
        var enemy:Entity = collide("enemy", x, y);
        if(enemy != null && !fallTimer.isActive()) {
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


    HXP.scene.camera.x = Math.floor(centerX / 160) * 160;
    HXP.scene.camera.y = Math.floor(centerY / 144) * 144;

    if(!prevCamera.equals(new Point(HXP.scene.camera.x, HXP.scene.camera.y))) {
      HUD.hud.clearMessages();
      if(collide("pit", x, y) != null) {
        return;
      }
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

  override private function takeDamage(enemy:Entity)
  {
    health -= 1;
    hitSfx.play();
    stunTimer.reset();
    invincibleTimer.reset();
    if(enemy.name == "nymph") {
      HUD.hud.echo("NYMPH MOANS APOLOGETICALLY");
    }
    if(health == 0) {
      deathSfx.play();
      GameScene.caveMusic.stop();
      deathTimer.reset();
      gameOverScreenTimer.reset();
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
    else if(castDurationTimer.isActive()) {
      sprite.play("cast_" + facing);
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
    health -= 1;
    if(health == 0) {
      deathSfx.play();
      GameScene.caveMusic.stop();
      deathTimer.reset();
      gameOverScreenTimer.reset();
    }
    if(!deathTimer.isActive()) {
      x = lastEntrance.x;
      y = lastEntrance.y;
      sprite.play(facing);
      stunTimer.reset();
      invincibleTimer.reset();
    }
  }

  private function castSpell()
  {
    velocity.x = 0;
    velocity.y = 0;
    HXP.scene.add(new Spell(Math.round(centerX), Math.round(centerY), facing));
    castCooldownTimer.reset();
    castDurationTimer.reset();
    castSfx.play();
  }

  public function isShadowVisible()
  {
    return rollTimer.isActive();
  }

}
