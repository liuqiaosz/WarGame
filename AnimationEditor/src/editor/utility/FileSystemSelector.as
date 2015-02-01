package editor.utility
{
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class FileSystemSelector
	{
		public function FileSystemSelector()
		{
		}
		
		/**
		 * 选择文件夹
		 **/
		public static function selectDirectory(complete:Function,title:String = "选择文件夹"):void
		{
			var selector:File = new File();
			selector.browseForDirectory(title);
			selector.addEventListener(Event.SELECT,function(event:Event):void{
				if(null != complete)
				{
					complete(selector.nativePath);
				}
			});
		}
		
		public static function selectChildFile(dirPath:String,progress:Function = null,complete:Function = null):void
		{
			var directory:File = new File(dirPath);
			var total:int = 0;
			var loaded:int = 0;
			var files:Array = null;
			var fileInfos:Vector.<FileInfo> = new Vector.<FileInfo>();
			var listComplete:Function = function(le:FileListEvent):void{
				files = le.files;
				if(files.length)
				{
					total = files.length;
					loadNext();
				}
				else
				{
					if(null != complete)
					{
						complete(fileInfos);
					}
				}
			};
			var curFile:File = null;
			var loadNext:Function = function():void{
				if(files.length)
				{
					curFile = files.shift();
					var info:FileInfo = new FileInfo();
					info.extension = curFile.extension;
					info.filePath = curFile.nativePath;
					info.name = curFile.name;
					var loader:URLLoader = new URLLoader();
					loader.dataFormat = URLLoaderDataFormat.BINARY;
					loader.addEventListener(Event.COMPLETE,function(ce:Event):void{
						info.data = loader.data as ByteArray;
						fileInfos.push(info);
						loaded++;
						if(null != progress)
						{
							progress(loaded,total);
						}
						loadNext();
					});
					loader.load(new URLRequest(curFile.nativePath));
				}
				else
				{
					complete(fileInfos);
				}
			};
			directory.addEventListener(FileListEvent.DIRECTORY_LISTING,listComplete);
			directory.getDirectoryListingAsync();
		}
	}
}