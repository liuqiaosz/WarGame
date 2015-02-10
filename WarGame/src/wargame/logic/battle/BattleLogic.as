package wargame.logic.battle
{
	import flash.geom.Point;
	
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	import lib.animation.avatar.cfg.AtomConfigManager;
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	
	import wargame.cfg.GameConfig;
	import wargame.cfg.vo.ConfigComponent;
	import wargame.cfg.vo.ConfigLevel;
	import wargame.cfg.vo.ConfigLevelArmy;
	import wargame.logic.GameLogicManager;
	import wargame.logic.IGameLogic;
	import wargame.logic.battle.vo.ArmyInfo;
	import wargame.logic.battle.vo.CampCmInfo;
	import wargame.logic.battle.vo.IBattleNode;
	import wargame.logic.battle.vo.SoliderInfo;
	import wargame.logic.battle.vo.SoliderNode;
	import wargame.logic.game.GameLogic;
	import wargame.logic.game.vo.SaveComponent;
	import wargame.logic.game.vo.SaveInfo;
	import wargame.scene.battle.sprite.Solider;
	import wargame.scene.menu.view.Test;
	import wargame.utility.NotifyIds;

	public class BattleLogic implements IGameLogic
	{
		public static const BATTLE_WIDTH:int = 2880;
		
		public static const FIGHT_PVE:int = 1;
		public static const FIGHT_PVP:int = 2;
		
		public static const RIGHT_CAMP_POS:Point = new Point(2780,100);
		public static const LEFT_CAMP_POS:Point = new Point(100,100);
		
		private static var _instance:BattleLogic = null;
		public static function get instance():BattleLogic
		{
			if(!_instance)
			{
				_instance = new BattleLogic();
			}
			return _instance;
		}
		
		private var _fightType:int = 0;
		private var _fightLevelId:String = "";
		private var _fighting:Boolean = false;
		private var _selfClan:ArmyInfo = null;
		private var _enemyClan:ArmyInfo = null;
		private var _selfSoliders:Vector.<IBattleNode> = null;
		private var _enemySoliders:Vector.<IBattleNode> = null;
		private var _allSprite:Vector.<IBattleNode> = null;
		private var _fightLevel:ConfigLevel = null;
		private var _isFightLock:Boolean = false;
		public function BattleLogic()
		{
			addLogicListener(NotifyIds.LOGIC_BATTLE_REQUEST,onBattleRequest);
		}
		
		public function get fightType():int
		{
			return _fightType;
		}
		
		public function get enemyClan():ArmyInfo
		{
			return _enemyClan;
		}
		
		public function get selfClan():ArmyInfo
		{
			return _selfClan;
		}
		public function get fightLevel():ConfigLevel
		{
			return _fightLevel;
		}
		
		/**
		 * 请求战斗
		 **/
		private function onBattleRequest(args:Array):void
		{
			debug("发起请求[" + args.join(",") + "]");
			if(_isFightLock)
			{
				debug("锁定状态，可能是重复请求");
				return;
			}
		}
		
		//开始战斗
		public function startFight(type:int,... args:Array):void
		{
			//_fightType = type;
			_allSprite = new Vector.<IBattleNode>();
			_selfSoliders = new Vector.<IBattleNode>();
			_enemySoliders = new Vector.<IBattleNode>();
			
			if(type == FIGHT_PVE)
			{
				//PVE推图
				if(args && args.length)
				{
					_fightLevelId = args[0];//关卡ID
					var levelClass:int = args[1];//难度
					initBattleInfo(type,_fightLevelId,levelClass);
					
				}
			}
			else
			{
				//PVP对战
			}
			
			//_fighting = true;
			//GameLogicManager.instance.add(this);
		}
		
		/**
		 * 初始化战斗信息
		 **/
		private function initBattleInfo(type:int,levelId:String,levelClass:int = 0):void
		{
			_fightType = type;
			debug("初始化战斗数据");
			if(_fightType == FIGHT_PVE)
			{
				_fightLevelId = levelId;
				_fightLevel = GameConfig.instance.findLevelById(_fightLevelId);
				if(!_fightLevel)
				{
					//关卡配置不存在，异常
					debug("关卡配置异常,关卡[" + _fightLevelId + "]");
					sendLogicMessage(NotifyIds.LOGIC_BATTLE_INIT_ERR,_fightLevelId);
					return;
				}
				//构造NPC阵营数据
				_enemyClan = createEnemyClan();
				//构建玩家阵营数据
				_selfClan = createPlayerClan();
				//数据准备完成
				sendLogicMessage(NotifyIds.LOGIC_BATTLE_ENTER,_fightLevelId);
			}
			else	
			{
				debug("PVP");
			}
		}
		
		private function createEnemyClan():ArmyInfo
		{
			var clan:ArmyInfo = new ArmyInfo();
			//构建城堡组件
			var cominfo:CampCmInfo = null;
			for each(var comp:ConfigComponent in GameConfig.instance.defaultCampComponent)
			{
				cominfo = new CampCmInfo();
				cominfo.component = comp;
				cominfo.lv = _fightLevel.campCompLv;
				clan.campComs.push(cominfo);
			}
			var id:String = "";
			var unit:ConfigUnit = null;
			//构建可出战的单位
			for each(var army:ConfigLevelArmy in _fightLevel.armys)
			{
				unit = AtomConfigManager.instance.findUnitById(army.uintId);
				clan.solider.push(new SoliderInfo(unit,army.level));
			}
			clan.campLv = _fightLevel.campLv;
			clan.clan = ArmyInfo.ARMY_AI;
			clan.name = _fightLevel.name;
			clan.stationPoint = RIGHT_CAMP_POS;
			clan.createPoint = RIGHT_CAMP_POS;
			return clan;
		}
		
		private function createPlayerClan():ArmyInfo
		{
			var clan:ArmyInfo = new ArmyInfo();
			var cominfo:CampCmInfo = null;
			var id:String = "";
			var unit:ConfigUnit = null;
			
			if(isTest())
			{
				for each(var comp:ConfigComponent in GameConfig.instance.defaultCampComponent)
				{
					cominfo = new CampCmInfo();
					cominfo.component = comp;
					cominfo.lv = 1
					clan.campComs.push(cominfo);
				}
			}
			else
			{
				var info:SaveInfo = GameLogic.instance.saveInfo;
				for each(var saveComp:SaveComponent in info.campComs)
				{
					cominfo = new CampCmInfo();
					cominfo.component = GameConfig.instance.findCompById(saveComp.id);
					cominfo.lv = saveComp.lv;
					clan.campComs.push(cominfo);
				}
				
				//构建可出战的单位
				for each(var saveSol:ConfigLevelArmy in info.rushSoliders)
				{
					unit = AtomConfigManager.instance.findUnitById(saveSol.uintId);
					clan.solider.push(new SoliderInfo(unit,saveSol.level));
				}
				clan.campLv = info.camplv;
			}
			
			clan.clan = ArmyInfo.ARMY_PLAYER;
			clan.stationPoint = LEFT_CAMP_POS;
			clan.createPoint = LEFT_CAMP_POS;
			return clan;
		}
		
		//结束战斗
		public function endFight():void
		{
			GameLogicManager.instance.remove(this);
		}
		
		/**
		 * 创建一个士兵并且添加到战场
		 **/
//		public function appendToBattle(value:Solider):void
//		public function createSoliderToBattle(id:String,clan:int):Solider
		public function createSoliderToBattle(info:SoliderInfo,clan:int):Solider
		{
			var solider:Solider = new Solider(info.id,clan);
			var node:SoliderNode = new SoliderNode(solider,info);
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
		
		
		public function clearBattleInfo():void
		{
			_fightType = 0;
			_fighting = false;
			_selfClan = null;
			_enemyClan = null;
			var node:IBattleNode = null;
			if(_selfSoliders)
			{
				_selfSoliders.length = 0;
				_selfSoliders = null;
			}
			
			if(_enemySoliders)
			{
				_enemySoliders.length = 0;
				_enemySoliders = null;
			}
			
			if(_allSprite)
			{
				for each(node in _allSprite)
				{
					node.dispose();
				}
				_allSprite.length = 0;
				_allSprite = null;
			}
		}
		
		public function dispose():void
		{
			
		}
	}
}