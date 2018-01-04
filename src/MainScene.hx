import com.haxepunk.Scene;
import entities.GameTimer;

class MainScene extends Scene
{
	public override function begin()
	{

	}

	public override function update()
	{
		super.update();
		GameTimer.updateAll();
	}
}
