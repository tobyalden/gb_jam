import com.haxepunk.Engine;
import com.haxepunk.HXP;
import scenes.*;

class Main extends Engine
{

	override public function init()
	{
#if debug
		HXP.console.enable();
#end
        HXP.screen.scale = 3;
		HXP.scene = new Title();
	}

	public static function main() { new Main(); }

}
