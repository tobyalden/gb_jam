package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class HUD extends Entity
{
    public static inline var X_POSITION = 10;
    public static inline var Y_POSITION = 10;

    private var sprite:Spritemap;
    private var player:Player;

    public function new()
    {
      super(0, 0);
      sprite = new Spritemap("graphics/hearts.png", 90, 9);
      sprite.add("0", [0]);
      sprite.add("1", [1]);
      sprite.add("2", [2]);
      sprite.add("3", [3]);
      sprite.add("4", [4]);
      sprite.add("5", [5]);
      sprite.add("6", [6]);
      sprite.add("7", [7]);
      sprite.add("8", [8]);
      sprite.add("9", [9]);
      sprite.add("10", [10]);
      graphic = sprite;
      layer = -999999;
    }

    override public function update()
    {
      if(player == null) {
          player = cast(HXP.scene.getInstance("player"), Player);
      }
      if(player.health >= 0 && player.health <= 10) {
        x = Math.floor(player.centerX / HXP.screen.width) * HXP.screen.width + X_POSITION;
        y = Math.floor(player.centerY / HXP.screen.height) * HXP.screen.height + Y_POSITION;
        sprite.play(Std.string(player.health));
      }
      super.update();
    }
}
