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
    private var textDropshadow2:Text;
    private var textDropshadow3:Text;
    private var textDropshadow4:Text;
    private var textDropshadow5:Text;
    private var textDropshadow6:Text;
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
      sprite.smooth = false;
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
      text.smooth = false;
      //text.addStyle("default", {color: 0x072103, size: 8, bold: false});
      text.addStyle("default", {color: 0xDAEFD7, size: 8, bold: false});
      text.setTextProperty('richText', true);
      text.y = 110;
      text.x = -5;

      textDropshadow = new Text();
      textDropshadow.smooth = false;
      textDropshadow.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow.setTextProperty('richText', true);
      textDropshadow.y = 110 + 1;
      textDropshadow.x = text.x;

      textDropshadow2 = new Text();
      textDropshadow2.smooth = false;
      textDropshadow2.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow2.setTextProperty('richText', true);
      textDropshadow2.y = 110 - 1;
      textDropshadow2.x = text.x;

      textDropshadow3 = new Text();
      textDropshadow3.smooth = false;
      textDropshadow3.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow3.setTextProperty('richText', true);
      textDropshadow3.y = 110;
      textDropshadow3.x = text.x - 1;

      textDropshadow4 = new Text();
      textDropshadow4.smooth = false;
      textDropshadow4.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow4.setTextProperty('richText', true);
      textDropshadow4.y = 110;
      textDropshadow4.x = text.x + 1;

      textDropshadow5 = new Text();
      textDropshadow5.smooth = false;
      textDropshadow5.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow5.setTextProperty('richText', true);
      textDropshadow5.y = 110 + 1;
      textDropshadow5.x = text.x + 1;

      textDropshadow6 = new Text();
      textDropshadow6.smooth = false;
      textDropshadow6.addStyle("default", {color: 0x072103, size: 8, bold: true});
      textDropshadow6.setTextProperty('richText', true);
      textDropshadow6.y = 110 - 1;
      textDropshadow6.x = text.x - 1;

      prevMessage = "";
      currentMessage = "";
      messageTimer = new GameTimer(MESSAGE_DURATION);

      gameOverScreen = new Image("graphics/gameover.png");
      gameOverScreen.smooth = false;
      gameOverScreen.x = -10;
      gameOverScreen.y = -10;
      gameOverScreen.visible = false;

      hud = this;

      allGraphics = new Graphiclist([sprite, textDropshadow, textDropshadow2, textDropshadow3, textDropshadow4, textDropshadow5, textDropshadow6, text, gameOverScreen]);
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
        x = Math.floor(player.centerX / 160) * 160 + X_POSITION;
        y = Math.floor(player.centerY / 144) * 144 + Y_POSITION;
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
      textDropshadow2.richText = "<default>" + prevMessage + "\n" + currentMessage + "</default>";
      textDropshadow3.richText = "<default>" + prevMessage + "\n" + currentMessage + "</default>";
      textDropshadow4.richText = "<default>" + prevMessage + "\n" + currentMessage + "</default>";

      super.update();
    }
}
