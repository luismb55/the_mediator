package interfaces 
{
	import flash.display.Stage;
	
	public interface IPlayerInput 
	{
		function init(stage:Stage):void
		function dispose():void;
		
		function get upPressed():Boolean;
		function get downPressed():Boolean;
		function get leftPressed():Boolean;
		function get rightPressed():Boolean;
		function get spacebarPressed():Boolean;
		
		//function get testPressed():Boolean;
		
		function set enabled(value:Boolean):void;
	}
	
}