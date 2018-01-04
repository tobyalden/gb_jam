package scenes;

import com.haxepunk.*;
import entities.*;

class Ending extends Scene
{

  static public var endingType:String;

	public function new(_endingType:String)
	{
    endingType = _endingType;
		super();
	}

	public override function begin()
	{
    add(new Credits());
	}

	public override function update()
	{
		super.update();
		GameTimer.updateAll();
	}

}
