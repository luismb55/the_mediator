package screens 
{
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class StartScreen extends CoreStartScreen implements IScriptable 
	{
		public var start:Signal;
		
		public function StartScreen() 
		{
			super();
		
			start = new Signal();
		}
		
		public function init():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function update():void
		{
			if (GameManager.playerInput.spacebarPressed)
				start.dispatch();
		}
	}

}