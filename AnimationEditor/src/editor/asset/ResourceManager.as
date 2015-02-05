package editor.asset
{
	import editor.ui.EditorProgressManager;
	import editor.utility.FileInfo;
	import editor.utility.FileSystemTool;
	
	import flash.display.Bitmap;
	import flash.utils.Dictionary;

	public class ResourceManager
	{
		private static var _instance:ResourceManager = null;
		public static function get instance():ResourceManager
		{
			if(!_instance)
			{
				_instance = new ResourceManager();
			}
			return _instance;
		}
		
		public function ResourceManager()
		{
		}
		
		private var assetDict:Dictionary = new Dictionary();
		public function loadAssetDirectory(id:String,directory:String,complete:Function):void
		{
			if(id in assetDict)
			{
				if(null != complete)
				{
					complete(assetDict[id]);
				}
			}
			EditorProgressManager.instance.showProgress();
			//文件夹还没有加载子文件
			FileSystemTool.selectChildFile(directory,true,function(cur:int,total:int):void{
				EditorProgressManager.instance.update("Reading...",cur + "/" + total);
				
			},function(files:Vector.<FileInfo>):void{
				EditorProgressManager.instance.hideProgress();
				var imgs:Vector.<Bitmap> = new Vector.<Bitmap>();
				for each(var info:FileInfo in files)
				{
					imgs.push(info.content as Bitmap);
				}
				assetDict[id] = imgs;
				
				if(null != complete)
				{
					complete(assetDict[id]);
				}
			});
		}
		
		public function getAssetById(id:String):Vector.<Bitmap>
		{
			if(id in assetDict)
			{
				return assetDict[id]
			}
			return null;
				
		}
		
		public function hasAsset(id:String):Boolean
		{
			return (id in assetDict);
		}
	}
}