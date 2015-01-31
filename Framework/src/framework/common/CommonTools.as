package framework.common
{
	import flash.geom.Point;
	import flash.net.FileReference;
	
	import framework.common.vo.SchedulerItem;
	import framework.core.TimerScheduler;
	
	import starling.display.DisplayObject;

	public class CommonTools
	{
		public function CommonTools()
		{
		}
		
		/**
		 * URL提取文件名
		 */
		public static function getName(url:String):String
		{
			var matches:Array;
			var name:String;
			name = url is String ? url as String : (url as FileReference).name;
			url = url.replace(/%20/g, " "); // URLs use '%20' for spaces
			matches = /(.*[\\\/])?(.+)(\.[\w]{1,4})/.exec(url);
			if (matches && matches.length == 4) return matches[2];
			return "";
		}
		
		public static function getSuffix(url:String):String
		{
			return url.substr(url.lastIndexOf(".") + 1);
		}
		
		private static var isShake:Boolean = false;
		private static var pos:Point = new Point();
		private static var shakeTarget:DisplayObject = null;
		private static var seed:int = 0;
		private static var shakeOffset:int = 4;
		public static function shake(dis:DisplayObject,times:int = 500,offset:uint = 4,speed:uint = 32):void
		{  
			if(isShake)
			{  
				return;  
			}
			shakeTarget = dis;
			isShake = true;  
			pos = new Point(dis.x,dis.y);
			offsetXYArray = [0,0];  
			seed = 0;
			shakeOffset = offset;
			
			TimerScheduler.instance.registerScheduler(30,onShakeUpdate,(times / 30),function(v:SchedulerItem):void{
				
				shakeTarget.x = pos.x;
				shakeTarget.y = pos.y;
				shakeTarget = null;
				isShake = false;
			});
		}
		private static var offsetXYArray:Array = [0,0];
		private static function onShakeUpdate(item:SchedulerItem):void
		{
			offsetXYArray[seed%2] = (seed++)%4<2 ?0:shakeOffset;  
			shakeTarget.x = offsetXYArray[0] + pos.x;  
			shakeTarget.y = offsetXYArray[1] + pos.y; 
		}
	}
}