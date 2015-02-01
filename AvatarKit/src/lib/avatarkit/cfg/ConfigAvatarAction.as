package lib.avatarkit.cfg
{
	/**
	 * 动作
	 **/
	public class ConfigAvatarAction
	{
		//动作名称
		public var name:String = "";
		//开始帧
		public var start:int = 0;
		//结束帧
		public var end:int = 0;
		//帧间隔(毫秒)
		public var duration:int = 0;
		public var triggers:Vector.<ConfigActionTrigger> = null;
		public function ConfigAvatarAction()
		{
			triggers = new Vector.<ConfigActionTrigger>();
		}
		
		public function decode(value:Object):void
		{
			name = value.name;
			start = value.start;
			end = value.end;
			duration = value.duration;
			if(value.triggers && value.triggers is Array)
			{
				var trigger:ConfigActionTrigger = null;
				for each(var triggerCfg:Object in value.triggers)
				{
					trigger = new ConfigActionTrigger();
					trigger.decode(triggerCfg);
					triggers.push(trigger);
				}
			}
		}
	}
}