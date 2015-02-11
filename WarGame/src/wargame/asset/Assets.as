package wargame.asset
{
	import lib.animation.core.AnimAsset;

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
		
		/**
		 * 获取战场地图
		 * 
		 * 这里返回列表，后期可能加入场景的层次背景，这里先简单处理
		 **/
		public static function getBattleMap(id:String):Array
		{
			return [
				"assets/scene/battle/" + id + "_1" + TEXTURE_SUFFIX,
				"assets/scene/battle/" + id + "_2" + TEXTURE_SUFFIX
			];
		}
		
		/**
		 * 角色动画资源
		 **/
		public static function getAvatar(id:String):Array
		{
			return AnimAsset.getAvatarUrl(id);
		}
	}
}