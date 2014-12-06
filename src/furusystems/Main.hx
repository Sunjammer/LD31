package furusystems;

import com.furusystems.flywheel.utils.time.StopWatch;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.geom.Rectangle;
import flash.Lib;
import furusystems.audio.Music;
import furusystems.console.Console;
import furusystems.generator.Generator;
import furusystems.macro.FileUtils;
import furusystems.macro.GenMacros;
import furusystems.shaders.SimpleShader;
import furusystems.world.gfx.TimedPrinter;
using furusystems.world.gfx.TimedPrinter;
/**
 * Ludum Dare 31 "Entire Game on One Screen" (Shit theme)
 * @author Andreas Rønning
 */

class Main extends Sprite
{
	var console:furusystems.console.Console;
	var c3d:flash.display3D.Context3D;
	var time:Float;
	var step:Float;
	var musicID:Int;
		
	static var palette:Array<Company> = GenMacros.boom();
	
	
	public function new() 
	{
		super();
		addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
	}
	
	private function onAddedToStage(e:Event):Void 
	{
		removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		
		step = 1 / stage.frameRate;
		
		console = new Console();
		console.showSource = false;
		console.maxLines = 300;
		console.alpha = 0.98;
		console.setSize(new Rectangle(0, 0, stage.stageWidth, stage.stageHeight));
		
		addChild(console);
		
		TimedPrinter.run(FileUtils.getFileContent("assets/images/dangerous.txt"));
		"Done".run(SYSTEM);
		
		stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		stage.stage3Ds[0].requestContext3D();
	}
	
	
	function handleConsoleInput(str:String):Dynamic 
	{
		return null;
	}
	
	private function onContextCreated(e:Event):Void 
	{
		trace("Context ready");
		c3d = stage.stage3Ds[0].context3D;
		c3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0);
		
		run();
	}
	
	function run() 
	{
		time = 0.0;
		musicID = Music.play("audio/ms20mess.mp3", 2);
		
		trace(palette[0].buildings[0]);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onEnterFrame(e:Event):Void 
	{
		gameLoop();
	}
	
	inline function gameLoop() 
	{
		time += step;
		updateAudio();
		updateBackground();
	}
	
	function updateAudio() 
	{
		Music.update(step);
	}
	
	inline function updateBackground() 
	{
		var v = time % 0.1;
		c3d.clear(v,v,v);
		c3d.present();
	}
	
	static function main() 
	{
		var stage = Lib.current.stage;
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP_LEFT;
		stage.addChild(new Main());
	}
	
}