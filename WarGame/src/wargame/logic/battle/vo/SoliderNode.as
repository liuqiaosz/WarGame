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
		public static var Flag:int = 0;
		public static const STATE_IDLE:int = ++Flag;
		public static const STATE_MOVE:int = ++Flag;
		public static const STATE_ATTACK:int = ++Flag;
		public static const STATE_ATTACKING:int = ++Flag;
		public static const STATE_ATTACK_TRIGGER:int = ++Flag;
		public static const STATE_ATTACK_END:int = ++Flag;
		public static const STATE_HURT:int = ++Flag;
		public static const STATE_DEAD:int = ++Flag;
//		public static const STATE_DISPOSE:int = ++Flag;//丢弃状态
		
		private var _state:int = STATE_IDLE;
		public function get state():int
		{
			return _state;
		}
		public function set state(value:int):void
		{
			_state = value;
		}
//		private var _solider:Solider = null;
		private var _info:SoliderInfo = null;
		public function get info():SoliderInfo
		{
			return _info;
		}
		private var distanceMul:int = 0;
		private var _soliderPos:Point = new Point();
		private var attackRange:Rectangle = null;
		public var hp:int = 0;
		public function get soliderPos():Point
		{
			return _soliderPos;
		}
		
		public function SoliderNode(info:SoliderInfo,pos:Point)
		{
//			super(target);
			_info = info;
//			_solider =  target as Solider;
			
//			distanceMul = (_solider.clan == ArmyInfo.ARMY_PLAYER ? 1:-1);
			distanceMul = (info.clan == ArmyInfo.ARMY_PLAYER ? 1:-1);
//			_soliderPos.x = _solider.x;
//			_soliderPos.y = _solider.y;
			_soliderPos.x = pos.x;
			_soliderPos.y = pos.y;
			
			hp = _info.hp;
		}
		
		private var _hurtFlag:Boolean = false;
		private var _lockTarget:SoliderNode = null;
		override public function update(delta:int,left:Vector.<IBattleNode>,right:Vector.<IBattleNode>):void
		{
//			var targetClan:Vector.<IBattleNode> = (_solider.clan == ArmyInfo.ARMY_PLAYER ? right:left);
//			var targetClan:Vector.<IBattleNode> = (_solider.clan == ArmyInfo.ARMY_PLAYER ? right:left);
			var targetClan:Vector.<IBattleNode> = (_info.clan == ArmyInfo.ARMY_PLAYER ? right:left);
			switch(_state)
			{
				case STATE_IDLE:
				case STATE_MOVE:
					_lockTarget = findAttackTarget(targetClan) as SoliderNode ;
					if(_lockTarget)
					{
						//has target
						_state = STATE_ATTACK;
						trace(_info.id + "进入攻击状态,目标[" + _lockTarget.info.id + "]");
					}
					else
					{
						_state = STATE_MOVE;
						this.soliderPos.x += (distanceMul * _info.atom.speedByFrame);
//						this.soliderPos.x += (distanceMul * 0.5);
						//trace(_info.id + "移动,新坐标[" + soliderPos.toString() + "]");
					}
					break;
				case STATE_ATTACK:
					if(_lockTarget)
					{
						if(_lockTarget.state == STATE_DEAD)
						{
							_lockTarget = findAttackTarget(targetClan) as SoliderNode;
							if(!_lockTarget)
							{
								//no target in range
								_state = STATE_MOVE;
							}
						}
					}
					break;
				case STATE_ATTACK_TRIGGER:
					//触发器,设置当次攻击动作的伤害标记
					_hurtFlag = true;
					if(_lockTarget)
					{
						hurtAttackTarget(targetClan);
//						if(_lockTarget.state == STATE_DEAD)//目标死亡
//						{
//							_lockTarget = findAttackTarget(targetClan) as SoliderNode;
//							if(_lockTarget)
//							{
//								
//							}
//						}
					}
					else
					{
						_state = STATE_MOVE;
					}
					break;
				case STATE_ATTACK_END:
					//攻击动作结束
					if(!_hurtFlag)
					{
						//没有触发器触发伤害则在攻击动作完成后触发目标伤害
						if(_lockTarget)
						{
							hurtAttackTarget(targetClan);
						}
					}
					
					if(_lockTarget.state == STATE_DEAD)//目标死亡
					{
						_lockTarget = findAttackTarget(targetClan) as SoliderNode;
					}
					
					if(_lockTarget)
					{
						_state = STATE_ATTACK;
					}
					else
					{
						_state = STATE_MOVE;
					}
					_hurtFlag = false;
					break;
				case STATE_DEAD:
					//死亡
					//trace("玩家死亡");
					
					break;
//				case STATE_DISPOSE:
//					trace("销毁");
////					dispose();
//					break;
			}
		}
		
		private function hurtAttackTarget(target:Vector.<IBattleNode>):void
		{
			if(_lockTarget.state != STATE_DEAD)
			{
				//attack target
				_lockTarget.onAttack(this);
				_state = STATE_ATTACK;
				if(_lockTarget.state == STATE_DEAD)
				{
					//target is dead
					_lockTarget = findAttackTarget(target) as SoliderNode;
					if(!_lockTarget)
					{
						//no target in range
						_state = STATE_MOVE;
					}
				}
			}
			else
			{
				_lockTarget = findAttackTarget(target) as SoliderNode;
				if(!_lockTarget)
				{
					//no target in range
					_state = STATE_MOVE;
				}
			}
		}
		
		/**
		 * 查找对方阵营是否有在攻击范围
		 **/
		private function findAttackTarget(targetArmy:Vector.<IBattleNode>):IBattleNode
		{
//			var rangeX:int = _solider.x + (_solider.attackRange * distanceMul);
			var rangeX:int = _soliderPos.x + (_info.atom.atkRange * distanceMul);
			var pos:Point = null;
			var state:int = 0;
			for(var idx:int = 0; idx<targetArmy.length; idx++)
			{
				pos = SoliderNode(targetArmy[idx]).soliderPos;
				state = SoliderNode(targetArmy[idx]).state;
				if(distanceMul < 0)
				{
					if(pos.x > rangeX && pos.x < _soliderPos.x && state != STATE_DEAD)
					{
						//in range
						return targetArmy[idx];
					}
				}
				else
				{
					if(pos.x < rangeX && pos.x > _soliderPos.x && state != STATE_DEAD)
					{
						return targetArmy[idx];
					}
				}
			}
			return null;
		}

		/**
		 * 被攻击
		 **/
		public function onAttack(caster:SoliderNode):void
		{
			if(_state != STATE_DEAD)
			{
				//攻击方的攻击力
				var attack:int = caster.info.levelInfo.attack;
				hp -= attack;
				debug(_info.id + "受到[" + caster.info.id + "]的攻击，损失[" + attack + "]生命,剩余生命[" + hp + "]");
				if(hp <= 0)//死亡
				{
					hp = 0;
					_state = STATE_DEAD;
					debug(_info.id + "被" + caster.info.id + "干死了!!!!!");
				}
			}
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
		override public function dispose():void
		{
//			if(self)
//			{
//				//从场景中移除
//				Sprite(self).removeFromParent();
//			}
			super.dispose();
		}
	}
}