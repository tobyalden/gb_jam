
package entities;

import flash.geom.Point;
import com.haxepunk.Entity;
import com.haxepunk.HXP;
import com.haxepunk.graphics.Spritemap;

class ActiveEntity extends Entity
{
    public static inline var TIME_BETWEEN_EMOTES = 350;

    private var sprite:Spritemap;
    private var startPosition:Point;
    private var velocity:Point;
    private var playerRef:Player;
    private var emoteTimer:GameTimer;

    public function new(x:Int, y:Int)
    {
        super(x, y);
        startPosition = new Point(x, y);
        velocity = new Point(0, 0);
        emoteTimer = new GameTimer(TIME_BETWEEN_EMOTES);
    }

    public function getScreenCoordinates() {
      return new Point(
        Math.floor(centerX / HXP.screen.width),
        Math.floor(centerY / HXP.screen.height)
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

    public function emote()
    {
      // override this to make an active entity emit a console message
    }

    public function getPositionOnScreen()
    {
      return new Point(x % HXP.screen.width, y % HXP.screen.height);
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
