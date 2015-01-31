package framework.core
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import starling.display.Sprite;
	import starling.events.Touch;
	import starling.events.TouchEvent;
	import starling.events.TouchPhase;

	/**
	 * 游戏系统全局上下文
	 */
	public class GameContext
	{
		use namespace FrameworkNS;
		public static const STAND_WIDTH:Number = 1920;
		public static const STAND_HEIGHT:Number = 1080;
		private var _appDirectory:File = null;
		public function get appDirectory():File
		{
			return _appDirectory;
		}
		
		/**
		 * 应用的专用存储目录
		 */
		private var _appStorageDirectory:File = null;
		public function get appStorageDirectory():File
		{
			return _appStorageDirectory;
		}
		
		//全局上下文
		private static var _instance:GameContext = null;
		public function GameContext()
		{
			if(_instance)
			{
				throw new Error("Singlton Instance Error!");
			}
			//保存当前应用的安装目录
			_appDirectory = File.applicationDirectory;
			_appStorageDirectory = File.applicationStorageDirectory;
		}
		
		public function getAppVersion():String
		{
			var descriptor:XML = NativeApplication.nativeApplication.applicationDescriptor;
			var ns:Namespace = descriptor.namespaceDeclarations()[0];
			var versionNumber:String = descriptor.ns::versionNumber;
			return versionNumber;
		}
		
		public static function get instance():GameContext
		{
			if(!_instance)
			{
				_instance = new GameContext();
			}
			return _instance;
		}
		
		
		private var _stage:Sprite = null;
		public function get screenStage():Sprite
		{
			return _stage;
		}
		
		public function set screenStage(value:Sprite):void
		{
			_stage = value;
			
			
		}
		
		private var _flashStage:Stage = null;
		public function set flashStage(value:Stage):void
		{
			_flashStage = value;
		}
		public function get flashStage():Stage
		{
			return _flashStage;
		}
		
		private var _appArgs:Object = null;
		public function set appArgs(value:Object):void
		{
			_appArgs = value;
			if(_appArgs)
			{
				if("isRawUI" in _appArgs)
				{
					_isRawUI = _appArgs.isRawUI;
				}
			}
		}
		public function get appArgs():Object
		{
			return _appArgs;
		}
		
		private var _isRawUI:Boolean = true;
		public function get isRawUI():Boolean
		{
			return _isRawUI;
		}
		
		public function isIOS():Boolean {
			return (Capabilities.version.substr(0, 3) == "IOS");
		}
		
		public function isAndroid():Boolean {
			return (Capabilities.version.substr(0, 3) == "AND");
		}
		
		/**
		 * 判断是否是移动客户端。！！！注意，在模拟器上跑时，cpu是x86的！！！
		 * @return 
		 * 
		 */		
		public function get isMobileAir():Boolean{
			return Capabilities.playerType=="Desktop" && Capabilities.cpuArchitecture=="ARM";
			
		}
		
		public static const DEVICE_IOS:int = 1;
		public static const DEVICE_ANDROID:int = 2;
		public static const DEVICE_OTHER:int = 3;
		private var _device:int = 0;
		public function getDevice():int
		{
			var dev:String = Capabilities.version.substr(0, 3);
			switch(dev)
			{
				case "IOS":
					return DEVICE_IOS;
					break;
				case "AND":
					return DEVICE_ANDROID;
					break;
				default:
					return DEVICE_OTHER;
					break;
			}
			
		}
		
		public function get screenFullWidth():int
		{
			if(_flashStage)
			{
				return _flashStage.fullScreenWidth;
			}
			return 0;
		}
		
		public function get screenFullHeight():int
		{
			if(_flashStage)
			{
				return _flashStage.fullScreenHeight;
			}
			return 0;
		}
		
		/**
		 * 是否横屏模式
		 */
		public function isLandscapeMode():Boolean
		{
			return (_flashStage && _flashStage.fullScreenWidth > _flashStage.fullScreenHeight);
		}
		
		private var mode:String = null;
		/**
		 * 获取屏幕模式
		 */
		public function getScreenMode():String
		{
			if(!mode)
			{
				var size:int = isLandscapeMode() ? screenFullWidth : screenFullHeight;
				if(size >= 1024)
				{
					mode = "HD";
				}
				else
				{
					mode = "LD";
				}
			}
			mode = "HD";
			return mode;
		}
		
		private var _dpiScale:Number = 0;
		public function dpiScale():Number
		{
			if(_dpiScale == 0)
			{
				_dpiScale = Capabilities.screenDPI / 320;
			}
			return _dpiScale;
		}
		
		private var _screenScale:Number = 0;
		/**
		 * 屏幕分辨率的缩放率
		 **/
//		public function screenScale():Number
//		{
//			if(_screenScale == 0)
//			{
//				var scaleW:Number = screenFullWidth / STAND_WIDTH;
//				var scaleH:Number = screenFullHeight / STAND_HEIGHT;
//				_screenScale = Math.max(scaleW,scaleH);
//				
//				_scaleType = (_screenScale == scaleW ? SCALE_H:SCALE_V);
////				_screenScale = screenFullWidth / STAND_WIDTH;
////				_screenScale = STAND_HEIGHT /screenFullHeight;
//			}
//			return _screenScale;
//		}
		
		public function scaleRatio():Number
		{
//			if(!_screenScale)
//			{
//				var scaleW:Number = screenFullWidth / STAND_WIDTH;
//				var scaleH:Number = screenFullHeight / STAND_HEIGHT;
//				_screenScale = Math.max(scaleW,scaleH);
//				
//				_scaleType = (_screenScale == scaleW ? SCALE_H:SCALE_V);
//				
//				_realContentWidth = STAND_WIDTH * _screenScale;
//				_realContentHeight = STAND_HEIGHT * _screenScale;
//			}
			if(!_screenScale)
			{
//				var scaleW:Number = screenFullWidth / STAND_WIDTH;
//				var scaleH:Number = screenFullHeight / STAND_HEIGHT;
//				_screenScale = Math.max(scaleW,scaleH);
//				
//				_scaleType = (_screenScale == scaleW ? SCALE_H:SCALE_V);
//				
//				_realContentWidth = STAND_WIDTH * _screenScale;
//				_realContentHeight = STAND_HEIGHT * _screenScale;
				_screenScale = screenFullWidth / STAND_WIDTH;
			}
			
			return _screenScale;
		}
		
		public static const SCALE_H:int = 1;
		public static const SCALE_V:int = 1;
		
		private var _scaleType:int = 0;
		public function get scaleType():int
		{
			return _scaleType;
		}
		
		private var _realContentHeight:int = 0;
		public function get realContentHeight():int
		{
			if(!_realContentHeight)
			{
				_realContentHeight = (STAND_HEIGHT * scaleRatio());
//				_realContentHeight = (screenFullHeight * screenScale());
			}
			return _realContentHeight;
		}
		private var _realContentWidth:int = 0;
		public function get realContentWidth():int	
		{
			if(!_realContentWidth)
			{
				//				_realContentHeight = (STAND_HEIGHT * screenScale());
//				_realContentWidth = (screenFullWidth * scaleRatio());
			}
			return _realContentWidth;
		}
		
		public function isHD():Boolean
		{
			return false;
		}
		
		public var openSkill:Boolean = false;
		
	}
}