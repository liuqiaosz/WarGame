package wargame.asset
{
	import framework.module.asset.AssetManagerBase;

	public class BattleAssetManager extends AssetManagerBase
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