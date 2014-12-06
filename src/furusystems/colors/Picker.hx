package furusystems.colors;
import com.furusystems.flywheel.geom.Vector2D;
import com.furusystems.flywheel.utils.data.Color3;
import flash.display.BitmapData;
import flash.geom.Vector3D;
import furusystems.colors.Picker.Wheel;

/**
 * ...
 * @author Andreas Rønning
 */
@:bitmap("assets/color_wheel_365.png")
class Wheel extends flash.display.BitmapData
{
	
}
class Picker
{
	var wheel:BitmapData;
	var center:Vector2D;
	public function new() 
	{
		wheel = new Wheel(365, 365,false);
		center = new Vector2D();
		center.x = wheel.width * 0.5;
		center.y = wheel.height * 0.5;
	}
	static var utilVec:Vector2D = new Vector2D();
	
	public function getColor(angle:Float, magnitude:Float, saturation:Float = 1, brightnessValue:Float = 1):Int {
		saturation = 1 - saturation;
		utilVec.x = center.x + Math.cos(angle) * magnitude * center.x;
		utilVec.y = center.y + Math.sin(angle) * magnitude * center.y;
		utilVec.truncate(364);
		return cast(brightness(ColorUtils.desaturate(Color3.fromHex(wheel.getPixel(cast utilVec.x, cast utilVec.y)), saturation), brightnessValue), Color3).toHex();
	}
	
	public function getPalette(startAngle:Float, startMag:Float, spreadX:Float, spreadY:Float, saturation:Float = 1, brightnessValue:Float = 1):Palette {
		var main:Array<Int> = [];
		var complimentary:Array<Int> = [];
		for (i in 0...5) {
			var fac = (i / 5) - 0.5;
			var m = startMag - Math.random() * spreadY;
			main[i] = getColor(startAngle + fac * spreadX, m, saturation, brightnessValue);
			complimentary[i] = getColor((startAngle + 3.14) + fac * spreadX, m, saturation, brightnessValue);
		}
		return new Palette(main, complimentary);
	}
	
}