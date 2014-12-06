package furusystems.macro;
import furusystems.generator.Generator;
import furusystems.generator.Generator.Company;
import haxe.macro.Expr;

/**
 * ...
 * @author Andreas Rønning
 */
class GenMacros
{
	macro public static function boom():Expr {
		var p = Generator.genPalette(Std.random(10+20));
		return macro $v{p};
	}
}