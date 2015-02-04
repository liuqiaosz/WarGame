package lib.animation.effect.cfg
{
	public class ConfigEffect
	{
		public var id:String = "";
		public var name:String = "";
		public var duration:int = 80;
		public var scaleRatio:Number = 1;
		
		//重复播放次数
		public var loopCount:int = 0;
		//重复播放的起始帧
		public var loopOffset:int = 0;
		
		public function ConfigEffect()
		{
		}
		
		public static function decode(obj:Object):ConfigEffect
		{
			var cfg:ConfigEffect = new ConfigEffect();
			cfg.id = obj.id;
			cfg.name = obj.name;
			cfg.duration = int(obj.duration);
			cfg.scaleRatio = Number(obj.scaleRatio);
			cfg.loopCount = int(obj.loopCount);
			cfg.loopOffset = int(obj.loopOffset);
			return cfg;
		}
	}
}