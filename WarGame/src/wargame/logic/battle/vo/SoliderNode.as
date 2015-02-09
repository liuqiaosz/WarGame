package wargame.logic.battle.vo
{
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
		public static const STATE_FIRE:int = 3;
		public static const STATE_HURT:int = 4;
		public static const STATE_DEAD:int = 5;
		
		private var _state:int = STATE_IDLE;
		
		private var _solider:Solider = null;
		public function SoliderNode(target:IBattleSprite)
		{
			super(target);
			_solider =  target as Solider;
		}
		
		private var _lockTarget:Solider = null;
		private var _hasLock:Boolean = false;
		override public function update(delta:int,left:Vector.<IBattleNode>,right:Vector.<IBattleNode):void
		{
			switch(_state)
			{
				case STATE_IDLE:
				case STATE_MOVE:
					
					break;
				case STATE_FIRE:
					break;
			}
		}
		
		/**
		 * 向前走
		 **/
		private function moveForward():void
		{
			
		}
		
		
		/**
		 * 被攻击
		 **/
		public function onAttack():void
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