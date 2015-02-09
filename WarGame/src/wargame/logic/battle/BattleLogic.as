package wargame.logic.battle
{
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	
	import wargame.logic.GameLogicManager;
	import wargame.logic.IGameLogic;
	import wargame.logic.battle.vo.ArmyInfo;
	import wargame.logic.battle.vo.IBattleNode;
	import wargame.logic.battle.vo.SoliderNode;
	import wargame.scene.battle.sprite.Solider;

	public class BattleLogic implements IGameLogic
	{
		public static const FIGHT_PVE:int = 1;
		public static const FIGHT_PVP:int = 2;
		
		private static var _instance:BattleLogic = null;
		public static function get instance():BattleLogic
		{
			if(!_instance)
			{
				_instance = new BattleLogic();
			}
			return _instance;
		}
		
		public function BattleLogic()
		{
			
		}
		
		private var _fightType:int = 0;
		private var _fighting:Boolean = false;
		//开始战斗
		public function startFight(type:int,... args:Array):void
		{
			_fightType = type;
			_allSprite = new Vector.<IBattleNode>();
			_selfSoliders = new Vector.<IBattleNode>();
			_enemySoliders = new Vector.<IBattleNode>();
			
			if(type == FIGHT_PVE)
			{
				//PVE推图
			}
			else
			{
				//PVP对战
			}
			
			_fighting = true;
			GameLogicManager.instance.add(this);
		}
		
		//结束战斗
		public function endFight():void
		{
			GameLogicManager.instance.remove(this);
		}
		
		//我方阵营数据
		private var _selfClan:ArmyInfo = null;
		//敌方阵营数据
		private var _enemyClan:ArmyInfo = null;
		
		private var _selfSoliders:Vector.<IBattleNode> = null;
		private var _enemySoliders:Vector.<IBattleNode> = null;
		private var _allSprite:Vector.<IBattleNode> = null;
		
		/**
		 * 创建一个士兵并且添加到战场
		 **/
//		public function appendToBattle(value:Solider):void
		public function createSoliderToBattle(id:String,clan:int):Solider
		{
			var solider:Solider = = new Solider(id,clan):
			var node:SoliderNode = new SoliderNode(solider,_selfSoliders,_enemySoliders);
			if(clan == ArmyInfo.ARMY_PLAYER)
			{
				//我方阵营
				_selfSoliders.push(node);
				solider.moveTo(_selfClan.createPoint.x,_selfClan.createPoint.y);
			}
			else
			{
				_enemySoliders.push(node);
				//AI或者PVP玩家属于敌方阵营
				solider.moveTo(_enemyClan.createPoint.x,_enemyClan.createPoint.y);
			}
//			_allSprite.push(solider);
			_allSprite.push(node);
			return solider;
		}
		
		private var solider:Solider = null;
		public function update(delta:int):void
		{
			if(_fighting)
			{
				var count:int = _allSprite.length;
				var node:IBattleNode = null;
				var index:int = 0;
				for(var idx:int = 0; idx<count; idx++)
				{
					node = _allSprite.shift();
					node.update(delta,_selfSoliders,_enemySoliders);
					if(!node.isDispose())
					{
						_allSprite.unshift(node);	
					}
					else
					{
						index = _selfSoliders.indexOf(node);
						if(index >= 0)
						{
							_selfSoliders.splice(index,1);
							continue;
						}
						index = _enemySoliders.indexOf(node);
						if(index >= 0)
						{
							_enemySoliders.splice(index,1);
							continue;
						}
					}
				}
			}
		}
		
		public function dispose():void
		{
			
		}
		
	}
}