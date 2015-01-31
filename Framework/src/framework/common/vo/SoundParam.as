package framework.common.vo
{
	/**
	 * 音乐消息参数VO
	 */
	public class SoundParam
	{
		public var soundId:String = "";
		public var soundPath:String = "";
		public var repeatCount:int = 0;
		public var completeFunc:Function = null;
		public var vol:Number = 1;
		public var cache:Boolean = false;
		
		public function SoundParam(id:String,repeat:int = 0,func:Function = null,isCache:Boolean = false)
		{
			soundId = id;
			repeatCount = repeat;
			completeFunc = func;
			cache = isCache;
		}
	}
}