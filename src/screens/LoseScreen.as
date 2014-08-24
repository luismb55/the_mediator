package screens 
{
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class LoseScreen extends CoreLoseScreen implements IScriptable
	{
		public var restart:Signal;
		
		public function LoseScreen() 
		{
			super();
				
			restart = new Signal();
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
				restart.dispatch();
		}
		
	}

}