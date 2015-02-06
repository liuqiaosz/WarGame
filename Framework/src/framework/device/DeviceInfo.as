package framework.device
{
	public class DeviceInfo
	{
		public var screenWidth:int = 0;
		public var screenHeight:int = 0;
		public var type:int = 0;
		
		public function DeviceInfo(w:int,h:int,type:int)
		{
			screenWidth = w;
			screenHeight = h;
			this.type = type;
		}
	}
}