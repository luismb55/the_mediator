package screens 
{
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import interfaces.IScriptable;
	import org.osflash.signals.Signal;
	/**
	 * ...
	 * @author Luis Miguel Blanco
	 */
	public class GameScreen extends CoreGameScreen implements IScriptable
	{
		public var understanding:Number;
		public var moveZone:Rectangle;
		
		protected var _stallingTime:Number;
		
		protected var _casualties:int;
		
		public var mediator:Mediator;
		
		protected var _enemy:ConflictWorld;
		protected var _otherEnemy:ConflictWorld;
		
		protected var _assaults:Vector.<Assault>;
		
		// sound
		protected var _smallExplosionSound:ExplosionSmall;
		protected var _bigExplosionSound:ExplosionBig;
		protected var _winSound:VictorySound;
		protected var _lossSound:LossSound;
		protected var _screamSound:ScreamSound;
		protected var _blockSound:BlockSound;
		protected var _shootSound:ShootSound;
		
		public var win:Signal;
		public var lose:Signal;
		
		protected var debugSprite:Sprite;
		
		public function GameScreen() 
		{
			super();
			
			mediator = new Mediator(core_mediator);
			_enemy = new ConflictWorld(enemy,enemy_health_bar);
			_otherEnemy = new ConflictWorld(otherenemy, otherenemy_health_bar);
			moveZone = new Rectangle(
				conflict_zone.x - conflict_zone.width * 0.5, 
				conflict_zone.y - conflict_zone.height * 0.5, 
				conflict_zone.width, 
				conflict_zone.height);
		
			win = new Signal();
			lose = new Signal();
			
			_assaults = new Vector.<Assault>();
			
			_smallExplosionSound = new ExplosionSmall();
			_bigExplosionSound = new ExplosionBig();
			_winSound = new VictorySound();
			_lossSound = new LossSound();
			_screamSound = new ScreamSound();
			_blockSound = new BlockSound();
			_shootSound = new ShootSound();
			
			debugSprite = new Sprite();
		}
		
		public function init():void
		{
			understanding = 0.0;
			casualties = 0;
			
			mediator.init();
			mediator.x = mediator_spot.x;
			mediator.y = mediator_spot.y;
			
			_enemy.init();
			_enemy.x = enemy_spot.x;
			_enemy.y = enemy_spot.y;
			_enemy.assault.add(launchEnemyAssault);
			_enemy.destroyed.add(onWorldDestroyed);
			
			_otherEnemy.init();
			_otherEnemy.x = otherenemy_spot.x;
			_otherEnemy.y = otherenemy_spot.y;
			_otherEnemy.assault.add(launchOtherEnemyAssault);
			_otherEnemy.destroyed.add(onWorldDestroyed);
			
			// DEBUG
			//addChild(debugSprite);
		}
		
		public function dispose():void
		{
			// TODO
			_enemy.assault.remove(launchEnemyAssault);
			_enemy.destroyed.remove(onWorldDestroyed);
			_enemy.dispose();
			_otherEnemy.assault.remove(launchOtherEnemyAssault);
			_otherEnemy.destroyed.remove(onWorldDestroyed);
			_otherEnemy.dispose();
			
			var i:int = 0;
			
			for (i = 0; i < _assaults.length; i++) {
				if(contains(_assaults[i].coreAssault))
					stage.removeChild(_assaults[i].coreAssault);
				_assaults[i].blocked.remove(onAssaultBlocked);
				_assaults[i].hit.remove(onAssaultHit);
				_assaults[i].missed.remove(onAssaultMissed);
				_assaults[i].dispose();
			}
			_assaults.splice(0, _assaults.length);
		}
		
		public function update():void
		{
			// update the understanding TEMP
			understanding += Settings.UNDERSTANDING_SPEED * (1.0 / stage.frameRate);
			
			if(understanding >= 1.0){
				understanding = 1.0;
				win.dispatch();
				_winSound.play();
			}else if(understanding < 0){
				understanding = 0;
			}
				
			// moving the worlds
			var conflictWidth:Number = conflict_zone.width * 0.5 - understanding_zone.width * 0.5;
			
			_enemy.x = enemy_spot.x + conflictWidth * understanding;
			_otherEnemy.x = otherenemy_spot.x - conflictWidth * understanding;
			
			conflict_label.scaleX = conflict_label.scaleY = Math.max(0.2,1 - understanding);
			conflict_label.alpha = 1 - understanding;
			
			understanding_label.alpha = understanding;
			
			// Recalc moving zone
			moveZone.x = _enemy.x;
			moveZone.width = _otherEnemy.x - _enemy.x;
				
			_enemy.update();
			_otherEnemy.update();
			mediator.update();
			
			// Update assaults
			var i:int = 0;
			
			for (i = 0; i < _assaults.length; i++) {
				_assaults[i].update();
			}
			
			// DEBUG
			/*debugSprite.graphics.clear();
			debugSprite.graphics.beginFill(0xff0000);
			debugSprite.graphics.drawRect(moveZone.x, moveZone.y, moveZone.width, moveZone.height);
			debugSprite.graphics.endFill();*/
		}
		
		protected function onWorldDestroyed():void
		{
			_lossSound.play();
			lose.dispatch();
		}
		
		protected function launchEnemyAssault(launchPosition:Point):void
		{
			var localPosition:Point = globalToLocal(launchPosition);
			var targetSpot:Point = new Point(
				Math.random() * _otherEnemy.width + _otherEnemy.x, 
				Math.random() * _otherEnemy.height + _otherEnemy.y - _otherEnemy.height*0.5);
			
			var assault:Assault = new Assault(new CoreEnemyAssault(),Settings.ENEMY_DAMAGE,_otherEnemy, targetSpot, _smallExplosionSound);
			
			initializeAssault(assault,localPosition);
		}
			
		protected function launchOtherEnemyAssault(launchPosition:Point):void
		{
			var localPosition:Point = globalToLocal(launchPosition);
			
			var targetSpot:Point = new Point(
				Math.random() * _enemy.width + enemy.x - _enemy.width, 
				Math.random() * _enemy.height + _enemy.y - _enemy.height*0.5);
			
			var assault:Assault = new Assault(new CoreOtherenemyAssault(),Settings.OTHERENEMY_DAMAGE,_enemy, targetSpot, _bigExplosionSound);

			initializeAssault(assault, localPosition);
		}
		
		protected function initializeAssault(assault:Assault, position:Point):void
		{
			_assaults.push(assault);
			
			assault.init();
			assault.blocked.add(onAssaultBlocked);
			assault.hit.add(onAssaultHit);
			assault.missed.add(onAssaultMissed);
			
			stage.addChild(assault.coreAssault);
			assault.x = position.x;
			assault.y = position.y;
			
			// PLAY SOUND
			_shootSound.play();
		}

		protected function onAssaultBlocked(assault:Assault):void
		{
			removeAssault(assault);
			
			// PLAY_SOUND
			_blockSound.play();
		}
		
		protected function onAssaultHit(assault:Assault):void
		{
			// Make damage
			assault.targetWorld.health -= assault.damage;
			
			// Add casualties
			casualties += int(Math.random()*Math.round(assault.damage*Settings.POPULATION));
			
			removeAssault(assault);
			
			// PLAY_SOUND
			assault.explosionSound.play();
			
			// SHAKE CAMERA
		}
		
		protected function onAssaultMissed(assault:Assault):void
		{
			removeAssault(assault);
		}
		
		protected function removeAssault(assault:Assault):void
		{
			var i:int = 0;
			
			for (i = 0; i < _assaults.length; i++)
				if (_assaults[i] == assault)
					break;
			
			if (i < _assaults.length) {
				if (stage.contains(_assaults[i].coreAssault))
						stage.removeChild(_assaults[i].coreAssault);
				_assaults[i].dispose();
				_assaults.splice(i, 1);
			}
		}
		
		public function get casualties():int
		{
			return _casualties;
		}
		
		public function set casualties(num:int):void
		{
			_casualties = num;
			casualty_counter.text = _casualties.toString(); 
		}
	}

}