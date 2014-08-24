package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import flash.media.Sound;
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class Assault implements IScriptable 
	{
		protected static const ARRIVE_RADIUS:Number = 5.0;
		
		public var coreAssault:MovieClip;
		public var damage:Number;
		public var stall:Number;
		public var targetWorld:ConflictWorld;
		public var targetSpot:Point;
		
		public var explosionSound:Sound;
		
		public var hit:Signal;
		public var missed:Signal;
		public var blocked:Signal;
		
		public function Assault(coreAssault:MovieClip, damage:Number, stall:Number, targetWorld:ConflictWorld, targetSpot:Point, explosionSound:Sound ) 
		{
			this.coreAssault = coreAssault;
			this.damage = damage;
			this.stall = stall;
			this.targetWorld = targetWorld;
			this.targetSpot = targetSpot;
			this.explosionSound = explosionSound;
			
			hit = new Signal();
			missed = new Signal();
			blocked = new Signal();
		}
		
		public function init():void
		{
			
		}
		
		public function dispose():void
		{
			hit.removeAll();
			missed.removeAll();
			blocked.removeAll();
		}
		
		public function update():void
		{
			var direction:Point = targetSpot.subtract(position);
			var arrived:Boolean = direction.length < ARRIVE_RADIUS;
			
			direction.normalize(1.0);
			
			x += direction.x*Settings.ASSAULT_SPEED*(1.0 / coreAssault.stage.frameRate);
			y += direction.y*Settings.ASSAULT_SPEED*(1.0 / coreAssault.stage.frameRate);
			
			// Check collision
				// with mediator
				if (coreAssault.hitTestObject(targetWorld.coreWorld)) {
					hit.dispatch(this);
				}else if (coreAssault.hitTestObject(GameManager.mediator.coreMediator)) {
					blocked.dispatch(this);
				}else {
					if (arrived)
						missed.dispatch(this);
				}
		}
		
		protected function get position():Point
		{
			return new Point(x, y);
		}
		
		public function get x():Number
		{
			return coreAssault.x;
		}
		
		public function get y():Number
		{
			return coreAssault.y;
		}
		
		public function set x(x:Number):void
		{
			coreAssault.x = x;
		}
		
		public function set y(y:Number):void
		{
			coreAssault.y = y;
		}
	}

}