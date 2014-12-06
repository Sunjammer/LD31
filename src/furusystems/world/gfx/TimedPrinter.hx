package furusystems.world.gfx;
import furusystems.console.Console.LogLevel;
import haxe.Timer;

/**
 * ...
 * @author Andreas Rønning
 */
typedef Line = {
	str:String, level:LogLevel
}
class TimedPrinter
{

	static var buffer:Array<Line> = [];
	static var interval:Int = 33;
	public static function run(str:String, ?type:LogLevel) {
		if (type == null) type = INFO;
		var lines = str.split("\n");
		while (lines.length > 0) {
			buffer.push( { str:lines.shift(), level:type } );
		}
		Timer.delay(next, interval);
	}
	static function next() {
		if (buffer.length > 0) {
			var l = buffer.shift();
			trace(l.str, l.level);
			if(buffer.length>0) Timer.delay(next, interval);
		}
	}
	
}