package entities;

import com.haxepunk.*;
import com.haxepunk.graphics.*;

class HUD extends Entity
{
    public static inline var X_POSITION = 10;
    public static inline var Y_POSITION = 10;
    public static inline var MESSAGE_DURATION = 800;

    public static var hud:HUD;

    private var sprite:Spritemap;
    private var text:Text;
    private var textDropshadow:Text;
    private var allGraphics:Graphiclist;
    private var player:Player;

    private var currentMessage:String;
    private var prevMessage:String;

    private var messageTimer:GameTimer;
    private var gameOverScreen:Image;

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

      text = new Text();
      text.addStyle("default", {color: 0x072103, size: 8, bold: false});
      text.setTextProperty('richText', true);
      text.y = 110;
      text.x = -5;

      textDropshadow = new Text();
      textDropshadow.addStyle("default", {color: 0xDAEFD7, size: 8, bold: true});
      textDropshadow.setTextProperty('richText', true);
      textDropshadow.y = 110;
      textDropshadow.x = text.x;

      prevMessage = "";
      currentMessage = "";
      messageTimer = new GameTimer(MESSAGE_DURATION);

      gameOverScreen = new Image("graphics/gameover.png");
      gameOverScreen.x = -10;
      gameOverScreen.y = -10;
      gameOverScreen.visible = false;

      hud = this;

      allGraphics = new Graphiclist([sprite, textDropshadow, text, gameOverScreen]);
      graphic = allGraphics;
      layer = -999999;
    }

    public function showGameOver() {
      gameOverScreen.visible = true;
    }

    public function echo(message:String)
    {
      // this should definitely play a sound effect
      prevMessage = currentMessage;
      currentMessage = message;
    }

    public function clearMessages()
    {
      prevMessage = "";
      currentMessage = "";
    }

    override public function update()
    {
      // HEALTH
      if(player == null) {
          player = cast(HXP.scene.getInstance("player"), Player);
      }
      if(player.health >= 0 && player.health <= 10) {
        x = Math.floor(player.centerX / HXP.screen.width) * HXP.screen.width + X_POSITION;
        y = Math.floor(player.centerY / HXP.screen.height) * HXP.screen.height + Y_POSITION;
        sprite.play(Std.string(player.health));
      }

      // CONSOLE
      /*if(!messageTimer.isActive()) {
        messageTimer.reset();
        if(prevMessage == "") {
          currentMessage = "";
        }
        else {
          prevMessage = "";
        }
      }*/

      text.richText = "<default>" + prevMessage + "\n" + currentMessage + "</default>";
      textDropshadow.richText = "<default>" + prevMessage + "\n" + currentMessage + "</default>";

      super.update();
    }
}
