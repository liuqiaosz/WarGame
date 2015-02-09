package wargame.logic.battle.vo
{
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import starling.display.Sprite;
	
	import wargame.scene.battle.sprite.IBattleSprite;
	import wargame.scene.battle.sprite.Solider;

	/**
	 * 士兵单位
	 **/
	public class SoliderNode extends BattleNode
	{
		public static const STATE_IDLE:int = 1;
		public static const STATE_MOVE:int = 2;
		public static const STATE_FIGHT:int = 3;
		public static const STATE_HURT:int = 4;
		public static const STATE_DEAD:int = 5;
		
		private var _state:int = STATE_IDLE;
		public function get state():int
		{
			return _state;
		}
		private var _solider:Solider = null;
		private var _info:SoliderInfo = null;
		private var distanceMul:int = 0;
		private var _soliderPos:Point = new Point();
		private var attackRange:Rectangle = null;
		public function get soliderPos():Point
		{
			return _soliderPos;
		}
		public function SoliderNode(target:IBattleSprite,info:SoliderInfo)
		{
			super(target);
			_info = info;
			_solider =  target as Solider;
			
			distanceMul = (_solider.clan == ArmyInfo.ARMY_PLAYER ? 1:-1);
			_soliderPos.x = _solider.x;
			_soliderPos.y = _solider.y;
		}
		
		private var _lockTarget:SoliderNode = null;
		override public function update(delta:int,left:Vector.<IBattleNode>,right:Vector.<IBattleNode>):void
		{
			var targetClan:Vector.<IBattleNode> = (_solider.clan == ArmyInfo.ARMY_PLAYER ? right:left);
			switch(_state)
			{
				case STATE_IDLE:
				case STATE_MOVE:
					_lockTarget = findAttackTarget(targetClan);
					if(_lockTarget)
					{
						//has target
						_state = STATE_FIGHT;
					}
					else
					{
						move();
					}
					break;
				case STATE_FIGHT:
					if(_lockTarget)
					{
						if(_lockTarget.state != STATE_DEAD)
						{
							//attack target
							_lockTarget.onAttack(this);
							if(_lockTarget.state == STATE_DEAD)
							{
								//target is dead
								_lockTarget = findAttackTarget(targetClan);
								if(!_lockTarget)
								{
									//no target in range
									_state = STATE_MOVE;
								}
							}
						}
						else
						{
							_lockTarget = findAttackTarget(targetClan);
							if(!_lockTarget)
							{
								//no target in range
								_state = STATE_MOVE;
							}
						}
					}
					break;
			}
		}
		
		private function move():void
		{
			
		}
		
		
		/**
		 * 查找对方阵营是否有在攻击范围
		 **/
		private function findAttackTarget(targetArmy:Vector.<IBattleNode>):IBattleNode
		{
			var rangeX:int = _solider.x + (_solider.attackRange * distanceMul);
			var pos:Point = null;
			for(var idx:int = 0; idx<targetArmy.length; idx++)
			{
				pos = SoliderNode(targetArmy[idx]).soliderPos;
				if(distanceMul < 0)
				{
					if(pos.x > rangeX && pos.x < _soliderPos.x)
					{
						//in range
						return targetArmy[idx];
					}
				}
				else
				{
					if(pos.x < rangeX && pos.x > _soliderPos.x)
					{
						return targetArmy[idx];
					}
				}
			}
		}

		/**
		 * 被攻击
		 **/
		public function onAttack(caster:SoliderNode):void
		{
			
		}
		
		/**
		 * 被锁定为目标
		 * 
		 **/
		public function onAttackLock(caster:IBattleNode):void
		{
			
		}
		
		/**
		 * 销毁节点
		 **/
		override protected function dispose():void
		{
			if(self)
			{
				//从场景中移除
				Sprite(self).removeFromParent();
			}
			super.dispose();
		}
	}
}