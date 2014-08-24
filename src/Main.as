package 
{
	import flash.display.Sprite;
	import flash.events.Event;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Main extends Sprite 
	{
		public var gameManager:GameManager;
		
		public function Main():void 
		{
			if (stage) init();
			else addEventListener(Event.ADDED_TO_STAGE, init);
		}
		
		private function init(e:Event = null):void 
		{
			removeEventListener(Event.ADDED_TO_STAGE, init);
			// entry point
			
			gameManager = new GameManager();
			gameManager.init(stage);
		}
	}
	
}