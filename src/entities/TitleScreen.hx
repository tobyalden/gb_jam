package entities;

import flash.system.System;
import com.haxepunk.*;
import com.haxepunk.utils.*;
import com.haxepunk.graphics.*;

class TitleScreen extends Entity
{
    private var titleScreen:Spritemap;

    public function new()
    {
      super(0, 0);
      titleScreen = new Spritemap("graphics/title_screen.png", 160, 144);
      titleScreen.add("default", [0, 1, 2, 3], 0.6, false);
      titleScreen.add("hold", [4, 3], 5, true);
      titleScreen.play("default");

      graphic = titleScreen;
      layer = -999999;
    }

    override public function update()
    {
      if(Input.check(Key.ESCAPE)) {
        System.exit(0);
      }

      if(titleScreen.complete || titleScreen.currentAnim == "hold") {
        titleScreen.play("hold");
        if(Input.check(Key.Z) || Input.check(Key.X)) {
          HXP.engine.scene = new scenes.GameScene();
        }
      }

      super.update();
    }
}
