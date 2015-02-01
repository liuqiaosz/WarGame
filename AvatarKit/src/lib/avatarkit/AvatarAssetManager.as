package lib.avatarkit
{
	import starling.utils.AssetManager;

	/**
	 * avatar资源管理器
	 **/
	public class AvatarAssetManager extends AssetManager
	{
		public static var _instance:AvatarAssetManager = null;
		public static function get instance():AvatarAssetManager
		{
			if(!_instance)
			{
				_instance = new AvatarAssetManager();
			}
			return _instance;
		}
		public function AvatarAssetManager()
		{
			
		}
		
		public function loadAvatarAsset(id:String,complete:Function = null):void
		{
			
		}
		
		/**
		 * 释放某个角色动画的全部资源
		 **/
		public function purgeAvatarAsset(id:String):void
		{
			this.removeTextureAtlas(id);
			this.removeXml(id);
			this.removeTexture(id);
		}
	}
}