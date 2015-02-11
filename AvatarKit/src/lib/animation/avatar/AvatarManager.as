package lib.animation.avatar
{
	import flash.utils.Dictionary;
	
	import lib.animation.avatar.cfg.ConfigAvatar;

	public class AvatarManager
	{
		private static var _instance:AvatarManager = null;
		public static function get instance():AvatarManager
		{
			if(!_instance)
			{
				_instance = new AvatarManager();
			}
			return _instance;
		}
		
		private var cfgDict:Dictionary = new Dictionary();
		
		public function AvatarManager()
		{
		}
		
		public function loadConfig(path:String):void
		{
			
		}
		
		public function loadConfigByJson(data:Array):void
		{
			if(data)
			{
				var avr:ConfigAvatar = null;
				for each(var obj:Object in data)
				{
					avr = ConfigAvatar.decode(obj);
					cfgDict[avr.id] = avr;
				}
			}
		}
		
		public function getConfig(id:String):ConfigAvatar
		{
			if(id in cfgDict)
			{
				return cfgDict[id];
			}
			return null;
		}
		
		public function getAvatar(id:String):IAvatar
		{
			if(id in cfgDict)
			{
				return new Avatar(cfgDict[id] as ConfigAvatar);
			}
			return null;
		}
			
	}
}