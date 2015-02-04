package lib.animation.avatar.cfg
{
	import lib.animation.avatar.AvatarEnum;

	/**
	 * 动作触发器
	 **/
	public class ConfigActionTrigger
	{
		public var name:String = "";
		public var triggerType:int = AvatarEnum.NONE;					//触发类型
		public var triggerFrame:int = 0;								//触发帧
		public var effectPosition:int = AvatarEnum.NONE;				//特效位置
		public var value:String = "";									//参数，触发类型为音效的时候值为音效文件名,类型为特效的时候值为特效ID
		public var offset:String = "";									//特效针对目标位置的偏移量
			
		public function ConfigActionTrigger()
		{
		}
		
		public static function decode(trigger:Object):ConfigActionTrigger
		{
			var value:ConfigActionTrigger = null;
			if(trigger)
			{
				value = new ConfigActionTrigger();
				value.name = trigger.name;
				value.triggerType = trigger.triggerType;
				value.triggerFrame = trigger.triggerFrame;
				value.effectPosition = trigger.effectPosition;
				value.value = trigger.value;
				value.offset = trigger.offset;
			}
			return value;
		}
	}
}