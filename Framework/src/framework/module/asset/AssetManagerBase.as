package framework.module.asset
{
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.LoaderInfo;
	import flash.events.Event;
	import flash.events.IOErrorEvent;
	import flash.events.ProgressEvent;
	import flash.filesystem.File;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.system.ApplicationDomain;
	import flash.system.LoaderContext;
	import flash.system.System;
	import flash.utils.ByteArray;
	import flash.utils.Dictionary;
	
	import framework.common.CommonTools;
	import framework.core.GameContext;
	import framework.module.BaseModule;
	
	import starling.textures.Texture;
	import starling.textures.TextureAtlas;
	import starling.utils.AssetManager;
	
	public class AssetManagerBase extends BaseModule
	{
		//等待任务队列
		private var waitQueue:Vector.<TaskInfo> = null;
		protected var starlingAsset:AssetManager = null;
		private var currentTask:TaskInfo = null;
		private var loading:Boolean = false;
		private var rawAssetDict:Dictionary = null;
		private var rawAssetIdDict:Dictionary = null;
		
		
		public function AssetManagerBase()
		{
			rawAssetDict = new Dictionary();
//			atlasBitmapDataDict = new Dictionary();
			rawAssetIdDict = new Dictionary();
			starlingAsset = new AssetManager();
			waitQueue = new Vector.<TaskInfo>();
			
			starlingAsset.keepAtlasXmls = true;
		}
		
		override public function initializer():void
		{
			super.initializer();
			
		}
		
		
		/**
		 * 添加一个加载队列
		 * 
		 * @param		queue		文件队列
		 * @param		onComplete	成功回调
		 * @param		onProgress	过程回调
		 * @param		raw			是否原生资源加载
		 */
		public function addLoadQueue(queue:Array,onComplete:Function = null,onProgress:Function = null):void
		{
//			var task:TaskInfo = ObjectPool.getInstanceOf(TaskInfo) as TaskInfo;
			var task:TaskInfo = new TaskInfo();
			task.queue = queue;
			task.completeFunc = onComplete;
			task.progressFunc = onProgress;
//			task.type = raw ? TaskInfo.TYPE_RAW:TaskInfo.TYPE_STARLING;
			if(loading)
			{
				waitQueue.push(task);
			}
			else
			{
				beginTask(task);
			}
		}
		public function addLoadTask(url:String,onComplete:Function = null,onProgress:Function = null):void
		{
			var task:TaskInfo = new TaskInfo();
			task.queue.push(url);
			task.completeFunc = onComplete;
			task.progressFunc = onProgress;
//			task.type = TaskInfo.TYPE_STARLING;
			if(loading)
			{
				//当前正在加载中,任务放入等待队列
				waitQueue.push(task);
			}
			else
			{
				beginTask(task);
			}
		}
		
		private var loader:URLLoader = null;
		private var assetFile:File = null;
		
		//		private var context:LoaderContext = new LoaderContext(false,ApplicationDomain.currentDomain);
		/**
		 * 开始一个下载任务
		 */
		private function beginTask(task:TaskInfo):void
		{
			loading = true;
			currentTask = task;
			var resolveFile:File = null;
			for each(var url:String in task.queue)
			{
				resolveFile = GameContext.instance.appDirectory.resolvePath(url);
				currentTask.lists.push(resolveFile);
			}
			
//			if(currentTask.type == TaskInfo.TYPE_STARLING)
//			{
//				starlingAsset.enqueue(currentTask.lists);
//				starlingAsset.loadQueue(onProgress);
//			}
//			else
//			{
//				beginRawTask();
//			}
			starlingAsset.enqueue(currentTask.lists);
			starlingAsset.loadQueue(onProgress);
		}
		
		private function beginRawTask():void
		{
			if(currentTask.lists.length)
			{
				loader = new URLLoader();
				loader.dataFormat = URLLoaderDataFormat.BINARY;
				loader.addEventListener(Event.COMPLETE,onRawLoadComplete);
				loader.addEventListener(ProgressEvent.PROGRESS,onRawLoadProgress);
				loader.addEventListener(IOErrorEvent.IO_ERROR,onRawLoadError);
				
				assetFile = currentTask.lists.shift();
				loader.load(new URLRequest(assetFile.url));
			}
			else
			{
				if(null != currentTask.completeFunc)
				{
					currentTask.completeFunc();
//					ObjectPool.returnInstance(currentTask);
					currentTask = null;
				}
			}
		}
		
		private function onRawLoadError(event:IOErrorEvent):void
		{
		}
		
		private function onRawLoadComplete(event:Event):void
		{
			var suffix:String = CommonTools.getSuffix(assetFile.url);
			var binary:ByteArray = loader.data as ByteArray;
			loader.removeEventListener(Event.COMPLETE,onRawLoadComplete);
			loader.removeEventListener(ProgressEvent.PROGRESS,onRawLoadProgress);
			loader.removeEventListener(IOErrorEvent.IO_ERROR,onRawLoadError);
			
			switch(suffix)
			{
				case "xml":
					var str:String = binary.readUTFBytes(binary.length);
					rawAssetDict[assetFile.url] = str;
					loader.data.clear();
					beginRawTask();
					break;
				case "png":
				case "jpg":
				case "jxr":
					var resLoader:Loader = new Loader();
					resLoader.contentLoaderInfo.addEventListener(Event.COMPLETE,onResLoadComplete);
					resLoader.loadBytes(binary,new LoaderContext(false,ApplicationDomain.currentDomain));
					break;
				default:
					rawAssetDict[assetFile.url] = loader.data;
					break;
			}
		}
		
		/**
		 * 
		 */
		private function onResLoadComplete(event:Event):void
		{
			var resLoader:LoaderInfo = event.target as LoaderInfo;
			resLoader.removeEventListener(Event.COMPLETE,onResLoadComplete);
			rawAssetDict[assetFile.url] = resLoader.content;
			loader.data.clear();
			beginRawTask();
		}
		
		private function onRawLoadProgress(event:ProgressEvent):void
		{
			
		}
		
		/**
		 * 
		 */
		private function onProgress(ratio:Number):void
		{
			if(null != currentTask.progressFunc)
			{
				currentTask.progressFunc(ratio);
			}
			if(ratio == 1)
			{
				if(null != currentTask.completeFunc)
				{
					currentTask.completeFunc();
				}
//				ObjectPool.returnInstance(currentTask);
				currentTask = null;
				if(waitQueue.length)
				{
					beginTask(waitQueue.shift() as TaskInfo);
				}
				else
				{
					loading = false;
				}
				
			}
		}
		
		/**
		 * 从大图获取指定前缀ID的纹理组
		 */
		public function getTexturesFromAtlas(id:String,prefix:String):Vector.<Texture>
		{
			var atlas:TextureAtlas = starlingAsset.getTextureAtlas(id);
			if(atlas)
			{
				return atlas.getTextures(prefix);
			}
			
			return null;
		}
		
		public function getTextureFromAtlas(atlasid:String,id:String):Texture
		{
			var atlas:TextureAtlas = starlingAsset.getTextureAtlas(atlasid);
			if(atlas)
			{
				return atlas.getTexture(id);
			}
			return null;
		}
		
		public function getTextureAtlas(name:String):TextureAtlas
		{
			return starlingAsset.getTextureAtlas(name);
		}
		public function removeTextureAtlas(name:String):void
		{
			starlingAsset.removeTextureAtlas(name);
			starlingAsset.removeTexture(name);
			starlingAsset.removeXml(name,true);
		}
		
		//		public function getRawAsset(url:String):Object
		//		{
		//			var file:File = GameContext.instance.appDirectory.resolvePath(url);
		//			if(file.url in rawAssetDict)
		//			{
		//				return rawAssetDict[file.url];
		//			}
		//			return null;
		//		}
		
		private var atlasBitmapDataDict:Dictionary = null;
		
		/**
		 * 获取纹理组
		 */
//		public function getBitmapsFromAtlas(url:String,prefix:String):Vector.<BitmapData>
//		{
//			var atlas:BitmapAtlas = null;
//			if(url in atlasBitmapDataDict)
//			{
//				atlas = atlasBitmapDataDict[url];
//			}
//			else
//			{
//				//先读取XML配置
//				var cfgFile:File = GameContext.instance.appDirectory.resolvePath(url + ".xml");
//				var resFile:File = GameContext.instance.appDirectory.resolvePath(url + ".png");
//				if(cfgFile.url in rawAssetDict && resFile.url in rawAssetDict)
//				{
//					var xmlStr:String = rawAssetDict[cfgFile.url];
//					var doc:XML = new XML(xmlStr);
//					
//					if(resFile.url in rawAssetDict)
//					{
//						atlas = atlasBitmapDataDict[url] = new BitmapAtlas(rawAssetDict[resFile.url].bitmapData,doc);
//						System.disposeXML(doc);
//					}
//				}
//			}
//			
//			if(atlas)
//			{
//				return atlas.getTextures(prefix);
//			}
//			
//			return null;
//		}
		
		/**
		 * 释放Atlas
		 */
//		public function diposeBitmapAtlas(name:String):void
//		{
//			if(name in atlasBitmapDataDict)
//			{
//				delete atlasBitmapDataDict[name];
//				starlingAsset.removeTextureAtlas(name,true);
//			}
//		}
		
		public function disposeTexture(name:String):void
		{
			starlingAsset.removeTexture(name);
		}
		
		public function getTexture(url:String):Texture
		{
			return starlingAsset.getTexture(url);
		}
		public function removeTexture(url:String):void
		{
			starlingAsset.removeTexture(url);
		}
		
		public function getByteArray(url:String):ByteArray
		{
			return starlingAsset.getByteArray(url);
		}
		public function removeByteArray(url:String):void
		{
			starlingAsset.removeByteArray(url,true);
		}
		
		public function getObject(url:String):Object
		{
			return starlingAsset.getObject(url);
		}
		public function removeObject(url:String):void
		{
			starlingAsset.removeObject(url);
		}
		
		public function purge():void
		{
			starlingAsset.purge();
			
			loading = false;
			waitQueue.length = 0;
			currentTask = null;
		}
		
		public function disposeByName(name:String):void
		{
			starlingAsset.removeByteArray(name);
			starlingAsset.removeObject(name);
			starlingAsset.removeTexture(name);
			starlingAsset.removeTextureAtlas(name);
		}
	}
}

/**
 * 批次任务数据
 */
class TaskInfo
{
//	public static const TYPE_STARLING:int = 1;
//	public static const TYPE_RAW:int = 2;
	
	public var queue:Array = [];
	public var completeFunc:Function = null;
	public var progressFunc:Function = null;
//	public var type:int = TYPE_STARLING;
	public var lists:Array = [];
	public function TaskInfo()
	{
		
	}
	
	public function reuse():void
	{
		queue = [];
		completeFunc = null;
		progressFunc = null;
//		type = TYPE_STARLING;
		lists.length = 0;
	}
	
}