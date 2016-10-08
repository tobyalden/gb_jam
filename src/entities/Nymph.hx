package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Nymph extends ActiveEntity
{

  public static inline var SPEED = 1;
  public static inline var OFFSCREEN_DISTANCE = 25;

  private var facing:String;
  private var isFalling:Bool;
  private var hasFallen:Bool;
  private var player:Player;

	public function new(x:Int, y:Int)
	{
		super(x, y);
    sprite = new Spritemap("graphics/nymph.png", 16, 16);
    sprite.add("down", [0, 1], 6);
    sprite.add("right", [2, 3], 6);
    sprite.add("left", [4, 5], 6);
    sprite.add("up", [6, 7], 6);
    sprite.add("fall", [8, 9, 10, 11], 3, false);
    sprite.play("down");
    facing = "down";
    setHitbox(11, 15, -3, -1);

    isFalling = false;
    hasFallen = false;

    type = "enemy";
    name = "nymph";
    layer = -9999;

		finishInitializing();
	}

  public override function update()
  {
    if(player == null) {
        player = cast(HXP.scene.getInstance("player"), Player);
    }

    if(player.isDead()) {
      sprite.stop();
      return;
    }

    if(!getScreenCoordinates().equals(player.getScreenCoordinates()))
    {
      if (
        distanceFrom(player) > OFFSCREEN_DISTANCE
      ) {
        return;
      }
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

    moveBy(velocity.x, velocity.y, ["walls", "enemy"]);

    var pit:Entity = collide("pit", x, y);
    if(isFalling || pit != null) {
      velocity.x = 0;
      velocity.y = 0;
      x = pit.x;
      y = pit.y;
      if(!isFalling) {
        HUD.hud.echo("NYMPH LETS OUT A MUFFLED CRY");
      }
      isFalling = true;
      type = "falling_soul";
    }

    if(Input.check(Key.ESCAPE)) {
      System.exit(0);
    }

    animate();

    checkDamage();

    super.update();
  }

  override private function takeDamage(spell:Entity)
  {
    HUD.hud.echo("NYMPH'S BODY ABSORBS YOUR SPELL");
  }

  private function animate()
  {
    if(isFalling) {
      sprite.play("fall");
      if(sprite.complete && !hasFallen) {
        hasFallen = true;
        HUD.hud.echo("YOU HEAR A DULL THUD");
      }
    }
    else {
      if(velocity.x != 0 || velocity.y != 0) {
        sprite.play(facing);
      }
      else {
        sprite.stop();
      }
    }
  }

}
