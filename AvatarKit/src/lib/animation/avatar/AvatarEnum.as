package lib.animation.avatar
{
	public class AvatarEnum
	{
		public static const NONE:int = 0;
		
		//触发器类型
		public static const Trigger_Effect:int = 1;//特效
		public static const Trigger_Audio:int = 2;//音效
		public static const Trigger_Event:int = 3;//事件,方便扩展
		public static const Trigger_Delay:int = 4;//延时
		
		//特效位置类型
		public static const EffectPosition_Self:int = 1;
		public static const EffectPosition_Target:int = 2;
		public static const EffectPosition_Screen:int = 3;
		
		public function AvatarEnum()
		{
		}
	}
}