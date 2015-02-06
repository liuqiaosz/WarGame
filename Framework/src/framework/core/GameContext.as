package framework.core
{
	import flash.desktop.NativeApplication;
	import flash.display.Stage;
	import flash.filesystem.File;
	import flash.system.Capabilities;
	
	import framework.device.Device;
	import framework.device.DeviceInfo;
	import framework.module.notification.NotificationIds;
	
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
		
		private var _currentDevice:DeviceInfo = null;
		/**
		 * 初始化Context
		 **/
		public function initContext(stageNative:Stage):Boolean
		{
			_flashStage = stageNative;
			//获得当前屏幕的宽和高确定设备类型	
			_currentDevice = Device.instance.getDeviceInfo(_flashStage.fullScreenWidth,_flashStage.fullScreenHeight);
			if(!_currentDevice)
			{
				//设置数据初始化失败
				return false;
			}
			
			if(_currentDevice.type == Device.DEVICE_IOS_IP4S)
			{
				//4,4S设备,使用1.5比率的素材和布局配置
				_designDeviceInfo = _currentDevice;
			}
//			else if(_currentDevice.type == Device.DEVICE_IOS_IPAD_AIR)
//			{
//				_designDeviceInfo = _currentDevice;
//			}
//			else if(_currentDevice.type == Device.DEVICE_IOS_IPAD_OLD)
//			{
//				//使用旧的IPAD设备则设计分辨率为高清设备
//				_designDeviceInfo = Device.instance.getDeviceInfoByType(Device.DEVICE_IOS_IPAD_AIR);
//			}
			else
			{
				//5,5S,6,6P设备，使用1.77的素材和布局配置
				//设计目标设备为6
				_designDeviceInfo = Device.instance.getDeviceInfoByType(Device.DEVICE_IOS_IP5S);
			}
			return true;
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
//		public function set flashStage(value:Stage):void
//		{
//			_flashStage = value;
//		}
		public function get flashStage():Stage
		{
			return _flashStage;
		}
		
		private var _appArgs:Object = null;
		public function set appArgs(value:Object):void
		{
			_appArgs = value;
		}
		public function get appArgs():Object
		{
			return _appArgs;
		}
		
		/**
		 * 判断是否是移动客户端。！！！注意，在模拟器上跑时，cpu是x86的！！！
		 * @return 
		 * 
		 */		
		public function get isMobileAir():Boolean
		{
			return Capabilities.playerType=="Desktop" && Capabilities.cpuArchitecture=="ARM";
		}
		
		public function get screenFullWidth():int
		{
			return this._designDeviceInfo.screenWidth;
		}
//		
		public function get screenFullHeight():int
		{
			return this._designDeviceInfo.screenHeight;
		}
		
		/**
		 * 是否横屏模式
		 */
		public function isLandscapeMode():Boolean
		{
			return (_flashStage && _flashStage.fullScreenWidth > _flashStage.fullScreenHeight);
		}
		
		
		private var _screenScale:Number = 0;
		public function scaleRatio():Number
		{
			if(!_screenScale)
			{
				_screenScale = _currentDevice.screenWidth / _designDeviceInfo.screenWidth;
			}
			return _screenScale;
		}
		
		private var _designDeviceInfo:DeviceInfo = null;
		/**
		 * 设计的标准分辨率
		 **/
		public function getDesignPixelAspect():DeviceInfo
		{
			return _designDeviceInfo;
		}
	}
}