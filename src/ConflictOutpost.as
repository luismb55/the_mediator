package  
{
	import flash.display.MovieClip;
	import flash.geom.Point;
	import interfaces.IScriptable;
	import com.greensock.TweenLite;
	import org.osflash.signals.Signal;
	
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class ConflictOutpost implements IScriptable 
	{
		public static const MAX_ASSAULT_WAIT:int = 10;
		public static const MIN_ASSAULT_WAIT:int = 2;
		
		public var coreOutpost:MovieClip;
		protected var _active:Boolean;
		
		protected var _attackFrequency:Number;
		
		public var assault:Signal;
		
		public function ConflictOutpost(coreOutpost:MovieClip) 
		{
			this.coreOutpost = coreOutpost;
			
			assault = new Signal();
		}
		
		public function init():void
		{
			_attackFrequency = MIN_ASSAULT_WAIT + Math.random() * (MAX_ASSAULT_WAIT - MIN_ASSAULT_WAIT);
			_active = true;
			coreOutpost.visible = true;
			TweenLite.delayedCall(_attackFrequency,launchAssault);
		}
		
		public function dispose():void
		{
			TweenLite.killDelayedCallsTo(launchAssault);
		}
		
		public function update():void
		{
			if (_active) {
				// TODO timer to shoot
			}
		}
		
		public function get active():Boolean 
		{
			return _active;
		}
		
		public function set active(value:Boolean):void 
		{
			if (value == _active)
				return;
				
			_active = value;
			
			coreOutpost.visible = _active;
			
			TweenLite.killDelayedCallsTo(launchAssault);
				
			if (_active) {
				TweenLite.delayedCall(_attackFrequency,launchAssault);
			}
		}
		
		protected function launchAssault():void
		{
			assault.dispatch((coreOutpost.launch_spot as MovieClip).localToGlobal(new Point(0, 0)));
			
			TweenLite.delayedCall(_attackFrequency,launchAssault);
		}
	}

}