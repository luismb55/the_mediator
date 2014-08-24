package  
{
	import flash.display.MovieClip;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.geom.Rectangle;
	import interfaces.IScriptable;
	import screens.*;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameManager 
	{
		public static const STATE_START:String = "state_start";
		public static const STATE_PLAYING:String = "state_playing";
		public static const STATE_WON:String = "state_won";
		public static const STATE_LOST:String = "state_lost";
		
		private var _stage:Stage;
		
		protected static var _startScreen:StartScreen;
		protected static var _gameScreen:GameScreen;
		protected static var _winScreen:WinScreen;
		protected static var _loseScreen:LoseScreen;
		
		public static var playerInput:KeyboardInput;
		
		private var _gameState:String;
		protected var _currentScreen:IScriptable;
		
		public function GameManager() 
		{
			_startScreen = new StartScreen();
			_gameScreen = new GameScreen();
			_winScreen = new WinScreen();
			_loseScreen = new LoseScreen();
			playerInput = new KeyboardInput();
			
		}
		
		public function init(stage:Stage):void 
		{
			if (_stage)
				_stage.removeEventListener(Event.ENTER_FRAME, update);
			
			_stage = stage;
	
			playerInput.init(_stage);
			
			_stage.addEventListener(Event.ENTER_FRAME, update);
			
			_startScreen.start.add(function():void { gameState = STATE_PLAYING } );
			_gameScreen.win.add(function():void { gameState = STATE_WON } );
			_gameScreen.lose.add(function():void { gameState = STATE_LOST } );
			_winScreen.restart.add(function():void { gameState = STATE_PLAYING } );
			_loseScreen.restart.add(function():void { gameState = STATE_PLAYING } );
			
			gameState = STATE_START;
		}
		
		public function update(e:Event):void 
		{
			_currentScreen.update();
		}
		
		public function dispose():void 
		{
			
		}
		
		public function get gameState():String 
		{
			return _gameState;
		}
		
		public function set gameState(newState:String):void 
		{
			if (newState == _gameState)
				return;
				
			if(_currentScreen)
				_currentScreen.dispose();
				
			switch(newState) {
				case STATE_START:
					_currentScreen = _startScreen
					break;
				case STATE_PLAYING :
					_currentScreen = _gameScreen;
					break;
				case STATE_WON :
					_currentScreen = _winScreen;
					break;
					
				case STATE_LOST :
					_currentScreen = _loseScreen;
					break;
				default:
					break;
			}
			if (_currentScreen && _stage.contains(_currentScreen as MovieClip))
				_stage.removeChild(_currentScreen as MovieClip);
				
			_stage.addChild(_currentScreen as MovieClip);
			_currentScreen.init();
			_gameState = newState;
		}
		
		public static function get understanding():int
		{
			return _gameScreen.understanding;
		}
		
		public static function get casualties():int
		{
			return _gameScreen.casualties;
		}
		
		public static function get moveZone():Rectangle
		{
			return _gameScreen.moveZone;
		}
		
		public static function get mediator():Mediator
		{
			return _gameScreen.mediator;
		}
	}

}