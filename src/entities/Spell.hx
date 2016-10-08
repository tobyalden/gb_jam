package entities;

import flash.geom.Point;
import flash.system.System;
import com.haxepunk.utils.*;
import com.haxepunk.*;
import com.haxepunk.graphics.*;
import entities.*;

class Spell extends ActiveEntity
{

  public static inline var SPEED = 2.5;
  public static inline var DRIFT_RATE = 60;
  public static inline var MAX_VELOCITY = 6;

  private var facing:String;

	public function new(x:Int, y:Int, facing:String)
	{
		super(x - 3, y - 3);
    sprite = new Spritemap("graphics/spell.png", 5, 5);
    sprite.add("idle", [0]);
    sprite.play("idle");
    this.facing = facing;
    setHitbox(5, 5);

    type = "spell";
    layer = -9998;

		finishInitializing();
	}

  public override function update()
  {
    if(facing == "up") {
      velocity.y = -SPEED;
    }
    else if(facing == "down") {
      velocity.y = SPEED;
    }
    else if(facing == "left") {
      velocity.x = -SPEED;
    }
    else if(facing == "right") {
      velocity.x = SPEED;
    }

    moveBy(velocity.x, velocity.y, "walls");

    super.update();
  }

  override public function moveCollideX(e:Entity)
  {
      HXP.scene.remove(this);
      return true;
  }

  override public function moveCollideY(e:Entity)
  {
    HXP.scene.remove(this);
    return true;
  }

}
