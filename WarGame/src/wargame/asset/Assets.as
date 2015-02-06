package wargame.asset
{
	/**
	 * 资源工具类
	 **/
	public class Assets
	{
		public static const ASSET_BASE:String = "assets/";
		public static const ASSET_UI:String = ASSET_BASE + "ui/";
		
		CONFIG::debug
		{
			public static const TEXTURE_SUFFIX:String = ".png";
		}
		
		CONFIG::release
		{
			public static const TEXTURE_SUFFIX:String = ".atf";
		}
		
		public function Assets()
		{
		}
		
		/**
		 * 获得资源的路径,后缀
		 **/
		public static function getAssetNativePath(value:String):String
		{
			return value + TEXTURE_SUFFIX;
		}
		
		public static function getUIAssetPath(atlas:String,id:String):String
		{
			CONFIG::debug
			{
				return ASSET_UI + atlas + "/" + id + TEXTURE_SUFFIX;
			}
			
			CONFIG::release
			{
				return ASSET_UI + atlas + TEXTURE_SUFFIX;
			}
		}
	}
}