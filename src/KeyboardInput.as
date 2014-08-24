package  
{
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	import interfaces.IPlayerInput;
	
	public class KeyboardInput implements IPlayerInput
	{
		private var _stage:Stage;
		
		private var _keysState:Dictionary = new Dictionary();
		private var _actionAvailable:Boolean = false;
		
		public function init(stage:Stage):void
		{
			_stage = stage;
	
			_stage.addEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			enabled = true;
		}
		
		public function dispose():void
		{
			_stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyUp);
			
			enabled = false;
		}
		
		public function get upPressed():Boolean 
		{
			return _keysState[38] || _keysState[87];
		}
		
		public function get downPressed():Boolean 
		{
			return _keysState[40] || _keysState[83];
		}
		
		public function get leftPressed():Boolean 
		{
			return _keysState[37] || _keysState[65];
		}
		
		public function get rightPressed():Boolean 
		{
			return _keysState[39] || _keysState[68];
		}
		
		public function get spacebarPressed():Boolean
		{
			return _keysState[32];
		}
		
		private function onKeyDown(e:KeyboardEvent):void
		{
			//trace("key down: " + e.keyCode);
			
			_keysState[e.keyCode] = true;
		}
		
		private function onKeyUp(e:KeyboardEvent):void
		{
			//trace("key up: " + e.keyCode);
			_keysState[e.keyCode] = false;
			if (e.keyCode == 32) _actionAvailable = true;
		}
		
		public function set enabled(value:Boolean):void
		{
			if (value)
			{
				_stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
			else
			{
				_stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyDown);
			}
		}
		
	}

}