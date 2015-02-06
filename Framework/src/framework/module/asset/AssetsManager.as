package framework.module.asset
{
	import starling.events.Event;
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	

	/**
	 * 资源管理器
	 * 
	 * 作为Starling资源管理器的代理模块,同时加入本地资源的管理
	 */
	public class AssetsManager extends AssetManagerBase
	{
		//等待任务队列
//		private var waitQueue:Vector.<TaskInfo> = null;
//		private var starlingAsset:AssetManager = null;
//		private var currentTask:TaskInfo = null;
//		private var loading:Boolean = false;
//		private var rawAssetDict:Dictionary = null;
//		private var rawAssetIdDict:Dictionary = null;
		private static var _instance:AssetsManager = null;
		public function AssetsManager()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
//			rawAssetDict = new Dictionary();
//			atlasBitmapDataDict = new Dictionary();
//			rawAssetIdDict = new Dictionary();

			starlingAsset.addEventListener(Event.TEXTURES_RESTORED,onTextureRestored);
		}
		
		public var onRestored:Function = null;
		
		private function onTextureRestored(event:Event):void
		{
			if(null != onRestored)
			{
				onRestored();
			}
		}
		
		public static function get instance():AssetsManager
		{
			if(!_instance)
			{
				_instance = new AssetsManager();
			}
			return _instance;
		}
		
		public function getUITexture(id:String,atlas:String = ""):Texture
		{
			if(atlas)
			{
				var textureAtlas:TextureAtlas = getTextureAtlas(atlas);
				if(textureAtlas)
				{
					return textureAtlas.getTexture(id);
				}
			}
			
			return getTexture(id);
		}
	}
}
