package wargame.scene.battle.sprite
{
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	
	import starling.display.Sprite;
	
	import wargame.logic.battle.vo.ArmyInfo;

	/**
	 * 
	 * 战斗原子单位,包含单位的AI处理和动画状态管理
	 * 
	 **/
	public class Solider extends Avatar implements IBattleSprite
	{
		private var _isHero:Boolean = false;	//是否英雄
		public function get isHero():Boolean
		{
			return _isHero;
		}
		private var _clan:int = 0;				//所属阵营
		public function get clan():int
		{
			return _clan;
		}

		private var _moveSpeed:Number = 0;
		private var _avatar:Avatar = null;
		public function Solider(id:String,clanV:int)
		{
			super(AvatarManager.instance.getConfig(id));
//			_avatar = avr;
			_clan = clanV;
			_moveSpeed = _avatar.atom.speedByFrame;
			if(ArmyInfo.ARMY_PLAYER != _clan)
			{
				_avatar.scaleX = -1;
				_moveSpeed *= -1;
			}
		}
		
		/**
		 * 被攻击
		 **/
		public function onAttack():void
		{
			
		}
		
		/**
		 * 普通攻击范围
		 **/
		public function get attackRange():int
		{
			if(_avatar)
			{
				return _avatar.atom.atkRange;
			}
			return 0;
		}
		
		//攻击类型，近战，远程
		public function get attackType():int
		{
			if(_avatar)
			{
				return _avatar.atom.atkType;
			}
			return 0;
		}
		
		public function moveTo(x:int,y:int):void
		{
			
		}
	}
}