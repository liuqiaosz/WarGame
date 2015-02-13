package wargame.logic.battle
{
	import flash.geom.Point;
	
	import framework.core.GameContext;
	import framework.module.notification.NotificationIds;
	import framework.module.scene.SceneManager;
	
	import lib.animation.avatar.Avatar;
	import lib.animation.avatar.AvatarManager;
	import lib.animation.avatar.cfg.AtomConfigManager;
	import lib.animation.avatar.cfg.atom.ConfigUnit;
	
	import wargame.asset.Assets;
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
	import wargame.scene.SceneIds;
	import wargame.scene.battle.sprite.Solider;
	import wargame.scene.menu.view.Test;
	import wargame.utility.NotifyIds;

	public class BattleLogic implements IGameLogic
	{
//		public static const BATTLE_WIDTH:int = 2880;
		public static const BATTLE_WIDTH:int = 1136;
		
		public static const FIGHT_PVE:int = 1;
		public static const FIGHT_PVP:int = 2;

		public static const RIGHT_CAMP_POS:Point = new Point(BATTLE_WIDTH - 50,GameContext.instance.getDesignPixelAspect().screenHeight - 100);
		public static const LEFT_CAMP_POS:Point = new Point(50,GameContext.instance.getDesignPixelAspect().screenHeight - 100);
		
		private static var _instance:BattleLogic = null;
		public static function get instance():BattleLogic
		{
			if(!_instance)
			{
				_instance = new BattleLogic();
			}
			return _instance;
		}
		
		private var inited:Boolean = false;
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
		private var _resourceList:Array = null;
		
		//双方的资源
		private var _selfWine:int = 0;
		private var _enemyWine:int = 0;
		
		public function BattleLogic()
		{
			
		}
		
		public function initializer():void
		{
			if(inited)
			{
				return;
			}
			addLogicListener(NotifyIds.LOGIC_BATTLE_REQUEST,onBattleRequest);
			inited = false;
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
			debug("收到战斗请求[" + args.join(",") + "]");
			if(_isFightLock)
			{
				debug("锁定状态，可能是重复请求");
				return;
			}
			_isFightLock = true;
			
			startFight(args[0],args[1]);
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
				debug("PVE");
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
			debug("初始化战斗数据");
			_fightType = type;
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
				//资源列表
				_resourceList = Assets.getBattleMap(_fightLevel.id);
				
				//构造NPC阵营数据
				_enemyClan = createEnemyClan(ArmyInfo.ARMY_AI);
				_enemyClan.level = _fightLevel.campLv;
				_enemyClan.campInfo = GameConfig.instance.findCampByLevel(_fightLevel.campLv);
				
				//构建玩家阵营数据
				_selfClan = createPlayerClan();
				//数据准备完成
				
				debug("战斗数据准备完毕,切换战斗场景");
				//SceneManager.instance.changeScene(SceneIds.SCENE_BATTLE);
				sendViewMessage(NotificationIds.MSG_VIEW_CHANGESCENE,SceneIds.SCENE_BATTLE);
				
				debug("发送进入战斗通知");
				sendLogicMessage(NotifyIds.LOGIC_BATTLE_ENTER,_resourceList);
				
				//添加开始消息监听
				addLogicListener(NotifyIds.LOGIC_BATTLE_BEGIN,onBattleBegin);
			}
			else	
			{
				debug("PVP");
			}
		}
		
		private function createEnemyClan(armyClan:int):ArmyInfo
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
				clan.solider.push(new SoliderInfo(unit,army.level,armyClan));
				_resourceList = _resourceList.concat(Assets.getAvatar(unit.id));
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
			
			if(isTest)
			{
				for each(var comp:ConfigComponent in GameConfig.instance.defaultCampComponent)
				{
					cominfo = new CampCmInfo();
					cominfo.component = comp;
					cominfo.lv = 1;
					clan.campComs.push(cominfo);
				}
				
				clan.solider.push(new SoliderInfo(AtomConfigManager.instance.findUnitById("20001"),1,ArmyInfo.ARMY_PLAYER));
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
					clan.solider.push(new SoliderInfo(unit,saveSol.level,ArmyInfo.ARMY_PLAYER));
					_resourceList = _resourceList.concat(Assets.getAvatar(unit.id));
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
		public function createSoliderToBattle(info:SoliderInfo,pos:Point):SoliderNode
		{
//			var solider:Solider = new Solider(info.id,clan);
//			var node:SoliderNode = new SoliderNode(solider,info,clan);
			var node:SoliderNode = new SoliderNode(info,pos);
			if(info.clan == ArmyInfo.ARMY_PLAYER)
			{
				//我方阵营
				_selfSoliders.push(node);
				//solider.moveTo(_selfClan.createPoint.x,_selfClan.createPoint.y);
			}
			else
			{
				_enemySoliders.push(node);
				//AI或者PVP玩家属于敌方阵营
				//solider.moveTo(_enemyClan.createPoint.x,_enemyClan.createPoint.y);
			}
//			_allSprite.push(solider);
			_allSprite.push(node);
			return node;
		}
		
		private var deltaSum:int = 0;
		//private var solider:Solider = null;
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
						_allSprite.push(node);	
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
				
				if(deltaSum >= 1000)
				{
					deltaSum = delta;
					
					//处理资源的更新
					_selfWine += (_selfClan.campLv * 10);
					_enemyWine += (_enemyClan.campLv * 10);
				}
				else
				{
					deltaSum += delta;
				}
				
				sendLogicMessage(NotifyIds.LOGIC_BATTLE_UPDATE);
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
		
		private function onBattleBegin(param:Object = null):void
		{
			removeLogicListener(NotifyIds.LOGIC_BATTLE_BEGIN,onBattleBegin);
			//战斗开始
			_fighting = true;
			addLogicListener(NotifyIds.LOGIC_BATTLE_ADD,onAddBattleNode);
			
			GameLogicManager.instance.add(this);
		}
		
		/**
		 * 
		 **/
		private function onAddBattleNode(args:Array):void
		{
			var uid:String = args[0];
			var clan:int = args[1];
			var info:SoliderInfo = null;
			var pos:Point = null;
			if(clan == ArmyInfo.ARMY_PLAYER)
			{
				//left
				info = _selfClan.findSoliderInfoById(uid);
				pos = LEFT_CAMP_POS;
			}
			else
			{
				//right	
				info = _enemyClan.findSoliderInfoById(uid);
				pos = RIGHT_CAMP_POS;
			}
			var node:SoliderNode = createSoliderToBattle(info,pos);
			sendLogicMessage(NotifyIds.LOGIC_BATTLE_ADDED,node);	
		}
		
		public function dispose():void
		{
			
		}
	}
}