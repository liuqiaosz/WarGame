package wargame.cfg.vo
{
	public class ConfigCamp
	{
		public var lv:int = 0;
		public var hp:int = 0;
		public var atk:int = 0;
		
		public function ConfigCamp()
		{
		}
		
		public static function decode(obj:Object):ConfigCamp
		{
			var titles:Array = obj.Title;
			var values:Array = obj.Value;
			var idx:int = 0;
			var camp:ConfigCamp = new ConfigCamp();
			for(idx = 0; idx<titles.length; idx++)
			{
				switch(titles[idx])
				{
					case "等级":
						camp.lv = int(values[idx]);
						break;
					case "生命":
						camp.hp = int(values[idx]);
						break;
					case "基础攻击":
						camp.atk = int(values[idx]);
						break;
				}
			}
			return camp;
		}
	}
}