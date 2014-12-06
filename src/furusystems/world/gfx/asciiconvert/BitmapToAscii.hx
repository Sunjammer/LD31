package furusystems.world.gfx.asciiconvert;
import com.furusystems.flywheel.utils.data.Color3;
import flash.display.BitmapData;
using furusystems.colors.ColorUtils;
/**
 * Mostly stolen from http://www.codeproject.com/Articles/20435/Using-C-To-Generate-ASCII-Art-From-An-Image
 * @author Andreas Rønning
 */
class BitmapToAscii
{
	static inline var BLACK = "@";
	static inline var CHARCOAL = "#";
	static inline var DARKGRAY = "8";
	static inline var MEDIUMGRAY = "&";
	static inline var MEDIUM = "o";
	static inline var GRAY = ":";
	static inline var SLATEGRAY = "*";
	static inline var LIGHTGRAY = ".";
	static inline var WHITE = " ";
	
	public static function convert(bmp:BitmapData, strideX:Int = 8, strideY:Int = 16):String {
		var temp = new Color3();
		var str = "";
		var y = 0;
		var yiter = 0;
		var xiter = 0;
		var liter = 0;
		while (y < bmp.height) {
			var x = 0;
			yiter++;
            while (x < bmp.width) {
				xiter++;
				temp.setFromHex(bmp.getPixel(x, y));
				temp.desaturate(1);
                str += getGrayShade(Std.int(temp.r * 255));

				x += strideX;
                if (x >= bmp.width - 1) {
					liter++;
					str += "\n";
				}
            }
			y += strideY;
        }
		return str;
	}
	
	static inline function getGrayShade(value:Int):String
	{
		var asciival = " ";

		if (value >= 230)
		{
			asciival = WHITE;
		}
		else if (value >= 200)
		{
			asciival = LIGHTGRAY;
		}
		else if (value >= 180)
		{
			asciival = SLATEGRAY;
		}
		else if (value >= 160)
		{
			asciival = GRAY;
		}
		else if (value >= 130)
		{
			asciival = MEDIUM;
		}
		else if (value >= 100)
		{
			asciival = MEDIUMGRAY;
		}
		else if (value >= 70)
		{
			asciival = DARKGRAY;
		}
		else if (value >= 50)
		{
			asciival = CHARCOAL;
		}
		else
		{
			asciival = BLACK;
		}
		return asciival;
	}
	
}