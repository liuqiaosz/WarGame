package editor.anim.avatar
{
	import flash.utils.Dictionary;
	
	import lib.animation.avatar.cfg.ConfigAvatar;

	public class AvatarManager
	{
		public static var _instance:AvatarManager = null;
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