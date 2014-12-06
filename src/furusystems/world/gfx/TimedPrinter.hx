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
	public static var interval:Int = 33;
	public static var fluctuation:Int = 66;
	public static var processor:Null < String->String > ;
	static var awaiting:Bool = false;
	public static function run(str:String, ?type:LogLevel) {
		if (type == null) type = INFO;
		var lines = str.split("\n");
		while (lines.length > 0) {
			buffer.push( { str:lines.shift(), level:type } );
		}
		if (!awaiting) {
			awaiting = true;
			Timer.delay(next, interval + Std.random(fluctuation));
		}
	}
	static function next() {
		if (buffer.length > 0) {
			var l = buffer.shift();
			
			if (processor == null) trace(l.str, l.level);
			else trace(processor(l.str), l.level);
			
			if (buffer.length > 0) {
				awaiting = true;
				Timer.delay(next, interval + Std.random(fluctuation));
			}else {
				awaiting = false;
			}
		}else {
			awaiting = false;
		}
	}
	
}