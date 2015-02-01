package lib.avatarkit.cfg
{
	public class ConfigAvatar
	{
		public var id:String;								//ID
		public var desc:String;							//描述
		public var resource:String;					//资源ID
		public var defaultAction:String = "";		//默认动作,一般选择待机动作作为默认动作
		public var actions:Vector.<ConfigAvatarAction> = null;
		
		public function ConfigAvatar()
		{
			actions = new Vector.<ConfigAvatarAction>();	
		}
		
		public function decode(value:Object):void
		{
			if(value)
			{
				id = value.id;
				desc = value.desc;
				resource = value.resource;
				
				if(value.actions && value.actions is Array)
				{
					var action:ConfigAvatarAction = null;
					for each(var act:Object in value.actions)
					{
						action = new ConfigAvatarAction();
						action.decode(act);
						actions.push(action);
					}
				}
			}
		}
	}
}