package editor.utility
{
	import flash.display.Loader;
	import flash.events.Event;
	import flash.events.FileListEvent;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;

	public class FileSystemTool
	{
		public function FileSystemTool()
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
		
		public static function selectChildFile(dirPath:String,isBitmap:Boolean = false,progress:Function = null,complete:Function = null):void
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
					if(isBitmap)
					{
						var bitmapLoader:Loader = new Loader();
						bitmapLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,function(be:Event):void{
							info.content = bitmapLoader.content;
							fileInfos.push(info);
							loaded++;
							if(null != progress)
							{
								progress(loaded,total);
							}
							loadNext();
						});
						bitmapLoader.load(new URLRequest(curFile.nativePath));
					}
					else
					{
						
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
				}
				else
				{
					complete(fileInfos);
				}
			};
			directory.addEventListener(FileListEvent.DIRECTORY_LISTING,listComplete);
			directory.getDirectoryListingAsync();
		}
		
		public static function readFile(nav:String):ByteArray
		{
			var file:File = new File(nav);
			if(file.exists && !file.isDirectory)
			{
				var reader:FileStream = new FileStream();
				reader.open(file,FileMode.READ);
				var data:ByteArray = new ByteArray();
				reader.readBytes(data);
				reader.close();
				return data;
			}
			return data;
		}
		
		public static function writeFile(nav:String,data:ByteArray):void
		{
			var file:File = new File(nav);
			if(file.exists && !file.isDirectory)
			{
				var writer:FileStream = new FileStream();
				writer.open(file,FileMode.WRITE);
				writer.writeBytes(data);
				writer.close();
			}
		}
	}
}