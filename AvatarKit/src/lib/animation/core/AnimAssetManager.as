package lib.animation.core
{
	import starling.utils.AssetManager;

	public class AnimAssetManager extends AssetManager
	{
		public static var _instance:AnimAssetManager = null;
		public static function get instance():AnimAssetManager
		{
			if(!_instance)
			{
				_instance = new AnimAssetManager();
			}
			return _instance;
		}
		
		public function AnimAssetManager()
		{
		}
		
		public function loadAnimAsset(id:String,complete:Function = null,progress:Function = null):void
		{
			
		}
	}
}