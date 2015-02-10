package wargame.cfg.vo
{
	public class ConfigComponent
	{
		public static const TYPE_RES:int = 1;
		public static const TYPE_DEF:int = 2;
		public static const TYPE_ATK:int = 3;
		
		//ID	名称	描述	类型	开启等级	默认开启	资源	范围	数值
		public var id:String;
		public var name:String;
		public var desc:String;
		public var type:int = 0;
		public var openLv:int = 0;
		public var defaultOpen:int = 0;
		
		public var levels:Vector.<ConfigComponentLv> = null;
		public function ConfigComponent()
		{
			levels = new Vector.<ConfigComponentLv>();
		}
		
		public static function decode(obj:Object):ConfigComponent
		{
			var config:ConfigComponent = null;
			var titles:Array = obj.Title;
			var values:Array = obj.Value;
			var idx:int = 0;
			for(idx = 0; idx<titles.length; idx++)
			{
				config = new ConfigComponent();
				switch(titles[idx])
				{
					case "ID":
						config.id = values[idx];
						break;
					case "名称":
						config.name = values[idx];
						break;
					case "描述":
						config.desc = values[idx];
						break;
					case "类型":
						switch(values[idx])
						{
							case "资源":
								config.type = TYPE_RES;
								break;
							case "防御":
								config.type = TYPE_DEF;
								break;
							case "攻击":
								config.type = TYPE_ATK;
								break;
						}

						break;
					case "开启等级":
						config.openLv = int(values[idx]);
						break;
					case "默认开启":
						if(values[idx] == "是")
						{
							config.defaultOpen = 1;
						}
						else
						{
							config.defaultOpen = 0;
						}
						break;
					
				}
			}
			
			var levelTitles:Array = obj.SubTitle;
			var levelValues:Array = obj.SubValue;
			var lv:ConfigComponentLv = null;
			for each(var levelValue:Array in levelValues)
			{
				lv = new ConfigComponentLv();
				for(idx = 0; idx<levelTitles.length; idx++)
				{
					
					switch(levelTitles[idx])
					{
						case "资源":
							lv.resource = levelValue[idx];
							break;
						case "范围":
							lv.range = int(levelValue[idx]);
							break;
						case "数值":
							lv.value = int(levelValue[idx]);
							break;
						
					}
				}
				config.levels.push(lv);
			}
			return config;
		}
	}
}