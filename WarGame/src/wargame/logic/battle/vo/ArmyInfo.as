package wargame.logic.battle.vo
{
	import flash.geom.Point;
	
	import wargame.cfg.vo.ConfigComponent;

	public class ArmyInfo
	{
		public static const ARMY_PLAYER:int = 1;		//玩家
		public static const ARMY_AI:int = 2;			//NPC
		public static const ARMY_PVP_PLAYER:int = 3;	//PVP玩家
		
		public var clan:int = 0;						//类型
		public var name:String = "";					//名称
		public var level:int = 0;						//等级
		public var heros:Vector.<HeroInfo>;				//英雄列表
		public var defaultWine:int;						//初始酒
		public var solider:Vector.<SoliderInfo>;		//普通兵种列表
		public var campComs:Vector.<CampCmInfo>; 		//当前科技等级
		public var campLv:int = 0;						//城堡等级
		
		public var createPoint:Point = new Point();		//阵营单位创建坐标
		public var stationPoint:Point = new Point();	//阵营主阵地坐标
		
		
		public function ArmyInfo()
		{
			campComs = new Vector.<CampCmInfo>();
			solider = new Vector.<SoliderInfo>();
		}
		
		public function findSoliderInfoById(id:String):SoliderInfo
		{
			for(var idx:int = 0; idx<solider.length; idx++)
			{
				if(solider[idx].id == id)
				{
					return solider[idx];
				}
			}
			return null;
		}
	}
}