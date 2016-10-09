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

    private var messageTimer:GameTimer;
    private var gameOverScreen:Image;

    private var messageIndex:Int;

    private var playerEndingText:Array<String> = [
      "HERE'S THE ENDIN TEXT1",
      "HERE'S THE ENDIN TEXT2",
      "HERE'S THE ENDIN TEXT3",
      "HERE'S THE ENDIN TEXT4",
      "HERE'S THE ENDIN TEXT5",
      "HERE'S THE ENDIN TEXT6",
      "HERE'S THE ENDIN TEXT7",
      "HERE'S THE ENDIN TEXT8",
      "HERE'S THE ENDIN TEXT9",
      "HERE'S THE ENDIN TXT10",
      "HERE'S THE ENDIN TXT11",
      "HERE'S THE ENDIN TXT12",
      "HERE'S THE ENDIN TXT13",
      "HERE'S THE ENDIN TXT14",
      "HERE'S THE ENDIN TXT15",
      "HERE'S THE ENDIN TXT16",
      "HERE'S THE ENDIN TXT17 ",
    ];

    public function new()
    {
      super(0, 0);

      text = new Text();
      text.addStyle("default", {color: 0xDAEFD7, size: 8, bold: false});
      text.setTextProperty('richText', true);
      text.y = 0;
      text.x = 0;

      messageIndex = 0;

      currentMessage = "";
      messageTimer = new GameTimer(MESSAGE_INTERVAL);
      messageTimer.reset();

      gameOverScreen = new Image("graphics/" + scenes.Ending.endingType + "_ending.png");
      gameOverScreen.visible = true;

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
      if(Input.check(Key.ESCAPE)) {
        System.exit(0);
      }

      if(!messageTimer.isActive()) {
        messageTimer.reset();
        if(messageIndex < playerEndingText.length) {
          echo(playerEndingText[messageIndex]);
          messageIndex += 1;
        }
      }


      super.update();
    }
}
