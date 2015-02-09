package lib.animation.avatar.cfg.atom
{
	/**
	 * 对应Unit.xlsx配置表
	 **/
	public class ConfigUnit
	{
		public var id:String = "";
		public var name:String = "";
		public var desc:String = "";
		public var unitType:int = 0;
		public var moveType:int = 0;
		public var atkType:int = 0;
		public var atkRange:int = 0;
		public var skill:String = "";
		public var specialSkill:String = "";
		public var speedByFrame:Number = 0;
		
		public var level:Vector.<ConfigUnitLevel> = null;
		public function ConfigUnit()
		{
			level = new Vector.<ConfigUnitLevel>();
		}
		
		public static function decode(unitObj:Object):ConfigUnit
		{
			var unit:ConfigUnit = new ConfigUnit();
			var titles:Array = unitObj.Title;
			var values:Array = unitObj.Value;
			var idx:int = 0;
			for(idx = 0; idx<titles.length; idx++)
			{
				switch(titles[idx])
				{
					case "ID":
						unit.id = values[idx];
						break;
					case "名称":
						unit.name = values[idx];
						break;
					case "单位类型":
						switch(values[idx])
						{
							case "普通召唤":
								unit.unitType = ConfigConstants.UNIT_TYPE_SOLDIER
								break;
							case "英雄":
								unit.unitType = ConfigConstants.UNIT_TYPE_HERO
								break;
							case "BOSS":
								unit.unitType = ConfigConstants.UNIT_TYPE_BOSS
								break;
						}
						break;
					case "行动类型":
						switch(values[idx])
						{
							case "地面":
								unit.moveType = ConfigConstants.UNIT_MOVE_FLOOR;
								break;
							case "飞行":
								unit.moveType = ConfigConstants.UNIT_MOVE_FLY;
								break;
						}
						break;
					case "攻击类型":
						switch(values[idx])
						{
							case "近战":
								unit.atkType = ConfigConstants.ATK_NEAR;
								break;
							case "远程":
								unit.atkType = ConfigConstants.ATK_FAR;
								break;
						}
						break;
					case "单位描述":
						unit.desc = values[idx];
						break;
					case "技能":
						unit.skill = values[idx];
						break;
					case "SP技能":
						unit.specialSkill = values[idx];
						break;
					case "伤害距离":
						unit.atkRange = int(values[idx]);
						break;
					case "移动速度":
						unit.speedByFrame = Number(values[idx]);
						break;
				}
			}
			
			var levelTitles:Array = unitObj.SubTitle;
			var levelValues:Array = unitObj.SubValue;
			var level:ConfigUnitLevel = null;
			for each(var levelValue:Array in levelValues)
			{
				level = new ConfigUnitLevel();
				for(idx = 0; idx<levelTitles.length; idx++)
				{
					switch(levelTitles[idx])
					{
						case "等级":
							level.lv = int(levelValue[idx]);
							break;
						case "升级花费":
							level.upgradeCost = int(levelValue[idx]);
							break;
						case "攻击":
							level.attack = int(levelValue[idx]);
							break;
						case "防御":
							level.defense = int(levelValue[idx]);
							break;
						case "生命":
							level.hp = int(levelValue[idx]);
							break;
						case "资源":
							level.resource = levelValue[idx];
							break;
					}
				}
				unit.level.push(level);
			}
			return unit;
		}
	}
}