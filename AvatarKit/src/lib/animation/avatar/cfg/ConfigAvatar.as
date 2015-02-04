package lib.animation.avatar.cfg
{
	public class ConfigAvatar
	{
		public var id:String;						//ID
		public var actions:Vector.<ConfigAvatarAction> = null;
		
		public function ConfigAvatar()
		{
			actions = new Vector.<ConfigAvatarAction>();	
		}
		
		public static function decode(value:Object):ConfigAvatar
		{
			var avatar:ConfigAvatar = null;
			if(value)
			{
				avatar = new ConfigAvatar();
				avatar.id = value.id;
				if(value.actions && value.actions is Array)
				{
					var action:ConfigAvatarAction = null;
					for each(var act:Object in value.actions)
					{
						action = ConfigAvatarAction.decode(act);
						avatar.actions.push(action);
					}
				}
			}
			return avatar;
		}
	}
}