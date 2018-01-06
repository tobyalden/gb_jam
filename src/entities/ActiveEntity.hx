
package entities;

import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.*;
import com.haxepunk.utils.*;
import com.haxepunk.graphics.Spritemap;

class ActiveEntity extends Entity
{
    public static inline var TIME_BETWEEN_EMOTES = 350;
    public static inline var DEFAULT_INVINCIBLE_TIME = 10;

    private var sprite:Spritemap;
    private var startPosition:Point;
    private var velocity:Point;
    private var playerRef:Player;
    private var emoteTimer:GameTimer;

    private var _hitSfx:Sfx;
    private var _deathSfx:Sfx;

    public var health:Int;
    private var invincibleTimer:GameTimer;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        startPosition = new Point(x, y);
        velocity = new Point(0, 0);
        emoteTimer = new GameTimer(TIME_BETWEEN_EMOTES);
        invincibleTimer = new GameTimer(DEFAULT_INVINCIBLE_TIME);
        _hitSfx = new Sfx("audio/hit.mp3");
        _deathSfx = new Sfx("audio/enemy_death.mp3");
    }

    public function getScreenCoordinates() {
      return new Point(
        Math.floor(centerX / 160),
        Math.floor(centerY / 144)
      );
    }

    public function finishInitializing()
    {
        sprite.smooth = false;
        graphic = sprite;
    }

    public override function update()
    {
        super.update();
        if(playerRef == null) {
            playerRef = cast(HXP.scene.getInstance("player"), Player);
        }
        if(!emoteTimer.isActive() && getScreenCoordinates().equals(playerRef.getScreenCoordinates()))
        {
          emote();
          emoteTimer.reset();
        }
        unstuck();
    }

    private function checkDamage() {
      var spell:Entity = collide("spell", x, y);
      if(spell != null && !invincibleTimer.isActive()) {
        cast(spell, Spell).explode();
        takeDamage(spell);
      }
    }

    private function takeDamage(spell:Entity)
    {
      health -= 1;
      invincibleTimer.reset();
      if(health <= 0) {
        _deathSfx.play();
        HXP.scene.add(new Explosion(Math.round(x), Math.round(y)));
        HXP.scene.remove(this);
      }
      else {
        _hitSfx.play();
      }
    }

    public function emote()
    {
      // override this to make an active entity emit a console message
    }

    public function getPositionOnScreen()
    {
      return new Point(x % 160, y % 144);
    }

    private function unstuck()
    {
        while(collide('walls', x, y) != null)
        {
          moveBy(0, -10);
        }
    }

    private function isAgainstWall()
    {
        return (
          collide("walls", x - 1, y) != null ||
          collide("walls", x + 1, y) != null ||
          collide("walls", x, y - 1) != null ||
          collide("walls", x, y + 1) != null
        );
    }

    private function isAgainstBottomWall()
    {
        return (
          collide("walls", x, y + 1) != null ||
          collide("pit", x, y + 1) != null
        );
    }

    private function isAgainstTopWall()
    {
        return (
          collide("walls", x, y - 1) != null ||
          collide("pit", x, y - 1) != null
        );
    }

    private function isAgainstRightWall()
    {
        return (
          collide("walls", x + 1, y) != null ||
          collide("pit", x + 1, y) != null
        );
    }

    private function isAgainstLeftWall()
    {
        return (
          collide("walls", x - 1, y) != null ||
          collide("pit", x - 1, y) != null
        );
    }
}
