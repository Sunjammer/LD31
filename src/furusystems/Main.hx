package furusystems;

import com.furusystems.flywheel.utils.time.StopWatch;
import flash.display.Bitmap;
import flash.display.Loader;
import flash.display.LoaderInfo;
import flash.display.Sprite;
import flash.display.StageAlign;
import flash.display.StageScaleMode;
import flash.events.Event;
import flash.filters.GlowFilter;
import flash.geom.Rectangle;
import flash.Lib;
import flash.net.URLRequest;
import furusystems.audio.Music;
import furusystems.console.Console;
import furusystems.generator.Generator;
import furusystems.macro.FileUtils;
import furusystems.macro.GenMacros;
import furusystems.shaders.SimpleShader;
import furusystems.world.gfx.asciiconvert.BitmapToAscii;
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
		console.outField.filters = [new GlowFilter(0xFFFFFF, 0.2, 16, 16, 1)];
		console.outField.mouseEnabled = false;
		
		addChild(console);
		
		console.createCommand("asciiArt", createAscii);
		
		createAscii("binaries/test.png");
		
		//TimedPrinter.run(FileUtils.getFileContent("assets/images/dangerous.txt"));
		//"Done".run(SYSTEM);
		
		stage.stage3Ds[0].addEventListener(Event.CONTEXT3D_CREATE, onContextCreated);
		stage.stage3Ds[0].requestContext3D();
	}
	
	function createAscii(url:String) 
	{
		var ldr = new Loader();
		ldr.contentLoaderInfo.addEventListener(Event.COMPLETE, onImageLoaded);
		ldr.load(new URLRequest(url));
	}
	
	
	function handleConsoleInput(str:String):Dynamic 
	{
		return null;
	}
	
	private function onContextCreated(e:Event):Void 
	{
		c3d = stage.stage3Ds[0].context3D;
		c3d.configureBackBuffer(stage.stageWidth, stage.stageHeight, 0);
		
		run();
	}
	
	function run() 
	{
		time = 0.0;
		musicID = Music.play("audio/ms20mess.mp3", 2);
		trace("...");
		
		trace("Welcome to "+palette[Std.random(palette.length)].name, SYSTEM);
		
		addEventListener(Event.ENTER_FRAME, onEnterFrame);
	}
	
	private function onImageLoaded(e:Event):Void 
	{
		var ldr:LoaderInfo = e.currentTarget;
		ldr.removeEventListener(Event.COMPLETE, onImageLoaded);
		var img = ldr.loader.content;
		var bmp:Bitmap = cast img;
		trace("Image loaded: " + bmp.bitmapData);
		BitmapToAscii.convert(bmp.bitmapData).run();
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
		var v = Math.random()*.5;
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