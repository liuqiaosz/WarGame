package editor.utility
{
	/**
	 * avatar配置管理器
	 **/
	public class AvatarConfigManager
	{
		private static var _instance:AvatarConfigManager = null;
		public static function get instance():AvatarConfigManager
		{
			if(!_instance)
			{
				_instance = new AvatarConfigManager();
			}
			return _instance;
		}
		
		public function refresh():void
		{
			var a:EditorStorageTools
		}
		
		public function AvatarConfigManager()
		{
		}
	}
}