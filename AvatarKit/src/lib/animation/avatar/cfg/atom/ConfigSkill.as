package lib.animation.avatar.cfg.atom
{
	import flashx.textLayout.elements.BreakElement;

	public class ConfigSkill
	{
		//ID	技能名称	攻击类型	解锁等级	技能范围	技能描述	技能效果	等级	升级花费	技能数值	SP消耗	资源
		public var id:String = "";
		public var name:String = "";
		public var atkType:int = 0;
		public var unlockLevel:int = 0;
		public var atkRange:int = 0;
		public var atkDistance:int = 0;
		public var desc:String = "";
		
		public var level:Vector.<ConfigSkillLevel> = null;
		
		public function ConfigSkill()
		{
			level = new Vector.<ConfigSkillLevel>();
		}
		
		public static function decode(skillObj:Object):ConfigSkill
		{
			var skill:ConfigSkill = new ConfigSkill();
			var titles:Array = skillObj.Title;
			var values:Array = skillObj.Value;
			var idx:int = 0;
			for(idx = 0; idx<titles.length; idx++)
			{
				switch(titles[idx])
				{
					case "ID":
						skill.id = values[idx];
						break;
					case "技能名称":
						skill.name = values[idx];
						break;
					case "攻击类型":
						switch(values[idx])
						{
							case "近战":
								skill.atkType = ConfigConstants.ATK_NEAR;
								break;
							case "远程":
								skill.atkType = ConfigConstants.ATK_FAR;
								break;
						}
						break;
					case "解锁等级":
						skill.unlockLevel = int(values[idx]);
						break;
					case "技能范围":
						switch(values[idx])
						{
							case "单个":
								skill.atkRange = ConfigConstants.ATK_RANGE_SINGLE;
								break;
							case "全体":
								skill.atkRange = ConfigConstants.ATK_RANGE_ALL;
								break;
						}
						
						break;
					case "技能描述":
						skill.desc = values[idx];
						break;
					case "伤害距离":
						skill.atkDistance = int(values[idx]);
						break;
				}
			}
			
			var levelTitles:Array = skillObj.SubTitle;
			var levelValues:Array = skillObj.SubValue;
			var level:ConfigSkillLevel = null;
			for each(var levelValue:Array in levelValues)
			{
				level = new ConfigSkillLevel();
				for(idx = 0; idx<levelTitles.length; idx++)
				{
					
					switch(levelTitles[idx])
					{
						case "等级":
							level.lv = levelValue[idx];
							break;
						case "升级花费":
							level.upgradeCost = int(levelValue[idx]);
							break;
						case "技能数值":
							level.value = int(levelValue[idx]);
							break;
						case "SP消耗":
							level.spCost = int(levelValue[idx]);
							break;
						case "资源":
							level.resource = levelValue[idx];
							break;
					}
				}
				skill.level.push(level);
			}
			return skill;
		}
	}
}