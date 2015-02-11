package wargame.asset
{
	import framework.module.asset.AssetManagerBase;
	
	import starling.utils.AssetManager;

	public class BattleAssetManager extends AssetManager
	{
		private static var _instance:BattleAssetManager = null;
		public static function get instance():BattleAssetManager
		{
			if(!_instance)
			{
				_instance = new BattleAssetManager();
			}
			return _instance;
		}
		public function BattleAssetManager()
		{
		}
	}
}