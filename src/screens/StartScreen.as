package screens 
{
	import flash.media.SoundChannel;
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class StartScreen extends CoreStartScreen implements IScriptable 
	{
		public var start:Signal;
		protected var _introMusic:IntroLoopSound;
		protected var _soundChannel:SoundChannel;
		
		public function StartScreen() 
		{
			super();
		
			start = new Signal();
			_introMusic = new IntroLoopSound();
		}
		
		public function init():void
		{
			_soundChannel = _introMusic.play(0, 9999);
		}
		
		public function dispose():void
		{
			_soundChannel.stop();
		}
		
		public function update():void
		{
			if (GameManager.playerInput.spacebarPressed)
				start.dispatch();
		}
	}

}