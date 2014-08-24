package screens 
{
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class WinScreen extends CoreWinScreen implements IScriptable
	{
		public var restart:Signal;
		
		public function WinScreen() 
		{
			super();
			
			restart = new Signal();
		}
		
		public function init():void
		{
			casualties_label.text = GameManager.casualties.toString();
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