package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import interfaces.IScriptable;
	import screens.GameScreen;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Mediator implements IScriptable
	{
		protected static const STATE_IDLE:String = "state_idle";
		protected static const STATE_WALKING:String = "state_walking";
		
		protected var _movement:Point;
		
		protected var _state:String = "state_idle";
		
		public var coreMediator:CoreMediator;
		
		public function Mediator(mediator:CoreMediator) 
		{
			super();
			
			coreMediator = mediator;
			_movement = new Point();
		}
		
		public function init():void
		{
			
		}
		
		public function dispose():void
		{
			
		}
		
		public function update():void
		{
			_movement.x = 0;
			_movement.y = 0;
			
			if (GameManager.playerInput.leftPressed)
				_movement.x -= 1;
			if (GameManager.playerInput.rightPressed)
				_movement.x += 1;
			if (GameManager.playerInput.upPressed)
				_movement.y -= 1;
			if (GameManager.playerInput.downPressed)
				_movement.y += 1;
				
			var canditatePosition:Point = new Point(x + _movement.x * Settings.MEDIATOR_SPEED, y + _movement.y * Settings.MEDIATOR_SPEED);
			
			checkCollisions(canditatePosition);
			
			x = canditatePosition.x;
			y = canditatePosition.y;
		}
		
		protected function checkCollisions(canditatePosition:Point):void
		{
			var moveZone:Rectangle = GameManager.moveZone;
			var halfMediatorSize:Number = coreMediator.width * 0.5;
			
			// Check x
			if (canditatePosition.x < moveZone.x + moveZone.width * 0.5) { // we are on the left
				if (canditatePosition.x - halfMediatorSize < moveZone.x)
					canditatePosition.x = moveZone.x + halfMediatorSize;
			}else{ // we are on the right
				if (canditatePosition.x + halfMediatorSize > moveZone.x + moveZone.width)
					canditatePosition.x = moveZone.x + moveZone.width - halfMediatorSize;
			}
			
			// Check y
			if (canditatePosition.y < moveZone.y + moveZone.height * 0.5) { // we are on the upper side
				if (canditatePosition.y - halfMediatorSize < moveZone.y)
					canditatePosition.y = moveZone.y + halfMediatorSize;
			}else { // we are on the lower side
				if (canditatePosition.y + halfMediatorSize > moveZone.y + moveZone.height)
					canditatePosition.y = moveZone.y + moveZone.height - halfMediatorSize;
			}
		}
		
		public function get x():Number
		{
			return coreMediator.x;
		}
		
		public function get y():Number
		{
			return coreMediator.y;
		}
		
		public function set x(x:Number):void
		{
			coreMediator.x = x;
		}
		
		public function set y(y:Number):void
		{
			coreMediator.y = y;
		}
	}

}