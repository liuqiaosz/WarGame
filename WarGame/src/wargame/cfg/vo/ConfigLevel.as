package wargame.cfg.vo
{
	public class ConfigLevel
	{
		
		public var id:String;
		public var name:String;
		public var desc:String;
		public var rewardMoney:int;
		public var rewardExp:int;
		public var rewardGoods:String;
		public var rewardRatio:Number;
		public var campLv:int = 0;
		public var campCompLv:int = 0;
		
		public var armys:Vector.<ConfigLevelArmy> = null;
		
		public function ConfigLevel()
		{
			
			
			armys = new Vector.<ConfigLevelArmy>();
		}
		
		public static function decode(obj:Object):ConfigLevel
		{
			//ID	名称	描述	奖励货币	奖励经验	掉落道具	掉落机率	NPC阵营等级	NPC阵营零件等级	出场单位
			var level:ConfigLevel = new ConfigLevel();
			var titles:Array = obj.Title;
			var values:Array = obj.Value;
			var idx:int = 0;
			for(idx = 0; idx<titles.length; idx++)
			{
				switch(titles[idx])
				{
					case "ID":
						level.id = values[idx];
						break;
					case "名称":
						level.name = values[idx];
						break;
					case "描述":
						level.desc = values[idx];
						break;
					case "奖励货币":
						level.rewardMoney = int(values[idx]);
						break;
					case "奖励经验":
						level.rewardExp = int(values[idx]);
						break;
					case "掉落道具":
						level.rewardGoods = values[idx];
						break;
					case "掉落机率":
						level.rewardRatio = Number(values[idx]);
						break;
					case "NPC阵营等级":
						level.campLv = int(values[idx]);
						break;
					case "NPC阵营零件等级":
						level.campCompLv = int(values[idx]);
						break;
				}
			}
			
			var levelTitles:Array = obj.SubTitle;
			var levelValues:Array = obj.SubValue;
			var army:ConfigLevelArmy = null;
			for each(var levelValue:Array in levelValues)
			{
				army = new ConfigLevelArmy();
				for(idx = 0; idx<levelTitles.length; idx++)
				{
					
					switch(levelTitles[idx])
					{
						case "出战单位":
							army.uintId= levelValue[idx];
							break;
						case "出战等级":
							army.level = int(levelValue[idx]);
							break;
						
					}
				}
				level.armys.push(army);
			}
			return level;
		}
	}
}