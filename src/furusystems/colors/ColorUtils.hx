package furusystems.colors;
import flash.geom.Vector3D;

/**
 * ...
 * @author Andreas Rønning
 */
class ColorUtils
{

	static var utilVec3 = new Vector3D();
	static var grayDot = new Vector3D(0.2126, 0.7152, 0.0722);
	static var black = new Vector3D();
	static public inline function brightness(vec:Vector3D, v:Float):Vector3D {
		return mix(black, vec, v);
	}
	static public inline function desaturate(vec:Vector3D, v:Float):Vector3D {
		var d = grayDot.dotProduct(vec);
		return mix(vec, new Vector3D(d, d, d), v);
	}
	public static inline function mix(a:Vector3D, b:Vector3D, v:Float):Vector3D {
		return new Vector3D(
			a.x + (b.x - a.x) * v,
			a.y + (b.y - a.y) * v,
			a.z + (b.z - a.z) * v);
	}
	
}