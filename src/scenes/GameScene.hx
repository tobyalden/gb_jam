package scenes;

import com.haxepunk.*;
import entities.*;

class GameScene extends Scene
{

	public static var caveMusic:Sfx;

	public function new()
	{
		super();
		caveMusic = new Sfx("audio/cave.ogg");
		caveMusic.loop();
	}

	public override function begin()
	{
    var level:Level = new Level("levels/cave.tmx");
		add(level);
		for (entity in level.entities) {
			add(entity);
		}
		caveMusic.loop();
	}

	public override function update()
	{
		super.update();
		GameTimer.updateAll();
	}

}
