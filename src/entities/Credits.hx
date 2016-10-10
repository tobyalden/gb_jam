package entities;

import flash.system.System;
import com.haxepunk.*;
import com.haxepunk.utils.*;
import com.haxepunk.graphics.*;

class Credits extends Entity
{
    public static inline var X_POSITION = 10;
    public static inline var Y_POSITION = 10;
    public static inline var MESSAGE_INTERVAL = 100;

    private var text:Text;
    private var textDropshadow:Text;
    private var allGraphics:Graphiclist;
    private var player:Player;

    private var currentMessage:String;

    private var endMusic:Sfx;

    private var messageTimer:GameTimer;
    private var gameOverScreen:Spritemap;

    private var messageIndex:Int;

    private var playerEndingText:Array<String> = [
      "YOU TOUCH THE CROWN",
      "THE AIR GROWS QUIET",
      "YOU HEAR A WHISPER",
      "WARM AND CLOSE",
      "IN YOUR EAR",
      "",
      "WHAT DO YOU WANT MOST",
      "WHO WOULD YOU BE",
      "IF YOU WEREN'T AFRAID",
      "",
      "LOOK INSIDE YOURSELF",
      "AND DO NOT BE AFRAID",
      "OF WHAT YOU SEE",
      "FOR ALL YOU SEE",
      "IS YOURSELF",
      " ",
      "               THE END",
    ];

    private var nymphEndingText:Array<String> = [
      "NYMPH TAKES THE CROWN",
      "AND PLACES IT ON THEM",
      "THANK YOU, THEY SAY",
      "",
      "YOU ARE ALL GONE NOW",
      "EXCEPT YOU, OF COURSE",
      "NOW, WE ARE ALL US",
      "AND WILL WE ALLOW YOU",
      "TO BE US AS WELL",
      "",
      "THEY TAKE YOUR HAND",
      "AND TOGETHER",
      "YOU BECOME ANOTHER",
      "",
      "THERE IS NO MORE WAR",
      "",
      "               THE END"
    ];

    public function new()
    {
      super(0, 0);

      text = new Text();
      text.addStyle("default", {color: 0xDAEFD7, size: 8, bold: false});
      text.setTextProperty('richText', true);
      text.y = 0;
      text.x = 0;

      scenes.GameScene.caveMusic.stop();
      endMusic = new Sfx("audio/" + scenes.Ending.endingType + "_ending.ogg");
      endMusic.play();

      messageIndex = 0;

      currentMessage = "";
      messageTimer = new GameTimer(MESSAGE_INTERVAL);
      messageTimer.reset();

      gameOverScreen = new Spritemap("graphics/" + scenes.Ending.endingType + "_ending.png", 160, 144);
      gameOverScreen.add("default", [0, 1, 2, 3], 0.5, false);
      gameOverScreen.play("default");

      allGraphics = new Graphiclist([gameOverScreen, text]);
      graphic = allGraphics;
      layer = -999999;
    }

    public function echo(message:String)
    {
      // this should definitely play a sound effect
      currentMessage += message  + "\n";
      text.richText = "<default>" + currentMessage + "</default>";
    }

    public function clearMessages()
    {
      currentMessage = "";
    }

    override public function update()
    {
      if(Input.check(Key.ESCAPE) || !endMusic.playing) {
        System.exit(0);
      }

      if(!gameOverScreen.complete) {
        messageTimer.reset();
      }
      if(!messageTimer.isActive()) {
        messageTimer.reset();
        if(messageIndex < playerEndingText.length) {
          if(scenes.Ending.endingType == "player") {
            echo(playerEndingText[messageIndex]);
          }
          else {
            echo(nymphEndingText[messageIndex]);
          }
          messageIndex += 1;
        }
      }


      super.update();
    }
}
