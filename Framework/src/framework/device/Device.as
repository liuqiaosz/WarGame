package framework.device
{
	import flash.utils.Dictionary;

	public class Device
	{
		public static const DEVICE_IOS_IP4S:int = 1;
		public static const DEVICE_IOS_IP5S:int = 2;
		public static const DEVICE_IOS_IP6:int = 3;
		public static const DEVICE_IOS_IP6P:int = 4;
		
		public static const DEVICE_IOS_IPAD_OLD:int = 10;//旧IPAD设备，IPAD2,MINI1
		public static const DEVICE_IOS_IPAD_AIR:int = 11;//新IPAD设备，IPADAIR+,MINI2+
		
		public static var _instance:Device = null;
		
		public static function get instance():Device
		{
			if(!_instance)
			{
				_instance = new Device();
			}
			
			return _instance;
		}
		
		private var _deviceDict:Dictionary = new Dictionary();
		
		public function Device()
		{
			var info:DeviceInfo = new DeviceInfo(960,640,DEVICE_IOS_IP4S);
			_deviceDict[DEVICE_IOS_IP4S] = info;
			
			info = new DeviceInfo(1136,640,DEVICE_IOS_IP5S);
			_deviceDict[DEVICE_IOS_IP5S] = info;
			
			info = new DeviceInfo(1334,750,DEVICE_IOS_IP6);
			_deviceDict[DEVICE_IOS_IP6] = info;
			
			info = new DeviceInfo(1920,1080,DEVICE_IOS_IP6P);
			_deviceDict[DEVICE_IOS_IP6P] = info;
			
			info = new DeviceInfo(2048,1536,DEVICE_IOS_IPAD_AIR);
			_deviceDict[DEVICE_IOS_IPAD_AIR] = info;
			
			info = new DeviceInfo(1024,768,DEVICE_IOS_IPAD_OLD);
			_deviceDict[DEVICE_IOS_IPAD_OLD] = info;
			
		}
		
		public function getDeviceInfo(screenW:int,screenH:int):DeviceInfo
		{
			if(screenW == 960 && screenH == 640)
			{
				return _deviceDict[DEVICE_IOS_IP4S];
			}
			else if(screenW == 1136)
			{
				return _deviceDict[DEVICE_IOS_IP5S];
			}
			else if(screenW == 1334)
			{
				return _deviceDict[DEVICE_IOS_IP6];
			}
			else if(screenW == 1920)
			{
				return _deviceDict[DEVICE_IOS_IP6P];
			}
			else if(screenW == 1024)
			{
				return _deviceDict[DEVICE_IOS_IPAD_OLD];
			}
			else if(screenW == 2048)
			{
				return _deviceDict[DEVICE_IOS_IPAD_AIR];
			}
			return null;
		}
		
		public function getDeviceInfoByType(type:int):DeviceInfo
		{
			if(type in _deviceDict)
			{
				return _deviceDict[type];
			}
			return null;
		}
	}
}