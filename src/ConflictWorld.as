package  
{
	import flash.display.DisplayObject;
	import flash.display.MovieClip;
	import flash.display.Sprite;
	import flash.geom.Point;
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	import screens.GameScreen;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class ConflictWorld implements IScriptable 
	{
		public static const MAX_HEALTH:int = 1.0;
		
		protected var _health:Number;
		
		// Bases
		protected var _outposts:Vector.<ConflictOutpost>;
		
		// Graphics
		public var healthBar:HealthBar;
		public var coreWorld:MovieClip;
		
		public var assault:Signal;
		public var destroyed:Signal;
		
		public function ConflictWorld(world:MovieClip, bar:HealthBar) 
		{
			super();
			
			coreWorld = world ? world : new MovieClip();
			healthBar = bar;
			
			_outposts = new Vector.<ConflictOutpost>();
			
			assault = new Signal();
			destroyed = new Signal();
		}
		
		public function init():void
		{
			health = MAX_HEALTH;
			
			initOutposts();
		}
		
		public function dispose():void
		{
			var i:int = 0;
			
			for (i = 0; i < _outposts.length; i++) {
				_outposts[i].assault.remove(assaultLaunched);
				_outposts[i].dispose();
			}
			_outposts.splice(0, numOutposts);
			
			assault.removeAll();
			destroyed.removeAll();
		}
		
		public function update():void
		{
			// update active outposts
			var i:int = 0;
			var activeOutposts:int;
			
			activeOutposts = Math.floor(numOutposts * 0.5 * (1.0 - _health) + numOutposts * 0.5*(1.0 - GameManager.understanding));
			
			for (i = 0; i < numOutposts; i++) {
				_outposts[i].active = i < activeOutposts;
			}
		}
		
		protected function initOutposts():void
		{
			var i:int = 0;
			var child:DisplayObject;
			var outpost:ConflictOutpost;
			
			for (i = 0; i < coreWorld.numChildren; i++) {
				child = coreWorld.getChildAt(i);
				
				if (child.name.indexOf("outpost") >= 0) {
					outpost = new ConflictOutpost(child as MovieClip);
					outpost.init();
					outpost.assault.add(assaultLaunched);
					
					_outposts.push(outpost);
				}
			}
		}

		protected function assaultLaunched(launchPosition:Point):void
		{
			assault.dispatch(launchPosition);
		}
		
		public function get numOutposts():int
		{
			return _outposts.length;
		}
		
		public function get x():Number
		{
			return coreWorld.x;
		}
		
		public function get y():Number
		{
			return coreWorld.y;
		}
		
		public function set x(x:Number):void
		{
			coreWorld.x = x;
		}
		
		public function set y(y:Number):void
		{
			coreWorld.y = y;
		}
		
		public function get width():Number
		{
			return coreWorld.width;
		}
		
		public function get height():Number
		{
			return coreWorld.height;
		}
		
		public function get health():Number
		{
			return _health;
		}
		
		public function set health(newHealth:Number):void
		{
			_health = newHealth;
			
			_health = _health < 0 ? 0 : (_health > 1.0 ? 1.0 : _health);
			
			healthBar.gotoAndStop(Math.ceil(_health * 100));
			
			if (_health <= 0)
				destroyed.dispatch();
		}
	}

}