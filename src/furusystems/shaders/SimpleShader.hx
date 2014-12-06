package furusystems.shaders;
import hxsl.Shader;
import hxsl.ShaderTypes.Matrix;
import hxsl.ShaderTypes.Texture;

/**
 * ...
 * @author Andreas Rønning
 */
class SimpleShader extends Shader
{
	static var SRC = {
        var input : { pos : Float3, uv : Float2 };
        var tuv : Float2;
        function vertex( mpos : Matrix, mproj : Matrix ) {
            out = input.pos.xyzw * mpos * mproj;
            tuv = input.uv;
        }
        function fragment( t : Texture ) {
            out = t.get(tuv,wrap);
        }
    }	
}