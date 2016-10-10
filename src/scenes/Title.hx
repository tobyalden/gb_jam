package scenes;

import com.haxepunk.*;
import entities.*;

class Title extends Scene
{

	public function new()
	{
		super();
	}

	public override function begin()
	{
    add(new TitleScreen());
	}

	public override function update()
	{
		super.update();
		GameTimer.updateAll();
	}

}
