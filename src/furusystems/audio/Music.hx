package furusystems.audio;
import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.net.URLRequest;

/**
 * ...
 * @author Andreas Rønning
 */
private class MusicStream {
	static var idPool = 0;
	public var startVolume:Float;
	public var fadeDuration:Float;
	public var targetVolume:Float;
	public var soundChannel:SoundChannel;
	public var time:Float;
	public var id:Int;
	public var stopping:Bool;
	public var playing:Bool;
	public function new(snd:Sound, startVolume:Float = 1.0, targetVolume:Float = 1.0, fadeDuration:Float = 0.0) {
		id = idPool++;
		this.startVolume = startVolume;
		this.fadeDuration = fadeDuration;
		this.targetVolume = targetVolume;
		time = 0.0;
		soundChannel = snd.play(0, -1, new SoundTransform(startVolume));
		playing = true;
		stopping = false;
	}
	public inline function setVolume(v:Float) {
		var t = soundChannel.soundTransform;
		t.volume = v;
		soundChannel.soundTransform = t;
	}
	public inline function getVolume():Float {
		return soundChannel.soundTransform.volume;
	}
	public inline function stop() {
		playing = false;
		soundChannel.stop();
	}
}
class Music
{
	static var pool = new Map<String,Sound>();
	static var streams = new Map<Int, MusicStream>();
	public static function update(delta:Float) {
		for (s in streams) {
			s.time += delta;
			var t = MathUtils.clamp(s.time / s.fadeDuration, 0.0, 1.0);
			s.setVolume(s.startVolume+(s.targetVolume-s.startVolume) * t);
			if (s.stopping && s.getVolume() < 0.01) {
				s.stop();
				trace(s.id+" stopped");
				streams.remove(s.id);
			}
		}
	}
	public static function play(path:String, fadeTime:Float = 0.0):Int {
		if (!pool.exists(path)) {
			pool[path] = new Sound(new URLRequest(path));
		}
		var str = new MusicStream(pool[path], 0, 1, fadeTime);
		streams[str.id] = str;
		return str.id;
	}
	public static function stop(id:Int, fadeTime:Float = 0.0) {
		if (id == -1) {
			for (i in streams.keys()) {
				stop(i, fadeTime);
			}
			return;
		}
		if (streams[id] != null) { 
			var s = streams[id];
			s.time = 0;
			s.fadeDuration = fadeTime;
			s.startVolume = s.getVolume();
			s.targetVolume = 0;
			s.stopping = true;
		}
	}
	
	
}